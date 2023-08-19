#include "appmodel.h"

#include <qgeopositioninfosource.h>
#include <qgeosatelliteinfosource.h>
#include <qnmeapositioninfosource.h>
#include <qgeopositioninfo.h>
#include <qnetworkconfigmanager.h>
#include <qnetworksession.h>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStringList>
#include <QTimer>
#include <QUrlQuery>
#include <QElapsedTimer>
#include <QLoggingCategory>

/*
 *This application uses http://openweathermap.org/api
 **/

#define ZERO_KELVIN 273.15

Q_LOGGING_CATEGORY(requestsLog,"wapp.requests")

WeatherData::WeatherData(QObject *parent) :
    QObject(parent)
{
}

WeatherData::WeatherData(const WeatherData &other) :
    QObject(0),
    m_dayOfWeek(other.m_dayOfWeek),
    m_weather(other.m_weather),
    m_weatherDescription(other.m_weatherDescription),
    m_temperature(other.m_temperature)
{
}

QString WeatherData::dayOfWeek() const
{
    return m_dayOfWeek;
}

/*!
 * The icon value is based on OpenWeatherMap.org icon set. For details
 * see http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
 *
 * e.g. 01d ->sunny day
 *
 * The icon string will be translated to
 * http://openweathermap.org/img/w/01d.png
 */
QString WeatherData::weatherIcon() const
{
    return m_weather;
}

QString WeatherData::weatherDescription() const
{
    return m_weatherDescription;
}

QString WeatherData::temperature() const
{
    return m_temperature;
}

QString WeatherData::minTemperature() const
{
    return m_minTemperature;
}

void WeatherData::setDayOfWeek(const QString &value)
{
    m_dayOfWeek = value;
    emit dataChanged();
}

void WeatherData::setWeatherIcon(const QString &value)
{
    m_weather = value;
    emit dataChanged();
}

void WeatherData::setWeatherDescription(const QString &value)
{
    m_weatherDescription = value;
    emit dataChanged();
}

void WeatherData::setTemperature(const QString &value)
{
    m_temperature = value;
    emit dataChanged();
}
void WeatherData::setMinTemperature(const QString &value)
{
    m_minTemperature = value;
    emit dataChanged();
}

class AppModelPrivate
{
public:
    static const int baseMsBeforeNewRequest = 5 * 1000; // 5 s, increased after each missing answer up to 10x
    QGeoPositionInfoSource *src;
    QGeoCoordinate coord;
    QString longitude, latitude;
    QString city;
    QNetworkAccessManager *nam;
    QNetworkSession *ns;
    WeatherData now;
    QList<WeatherData*> forecast;
    QQmlListProperty<WeatherData> *fcProp;
    bool ready;
    bool useGps;
    QElapsedTimer throttle;
    int nErrors;
    int minMsBeforeNewRequest;
    QTimer delayedCityRequestTimer;
    QTimer requestNewWeatherTimer;
    QString app_ident;

    AppModelPrivate() :
        src(NULL),
        nam(NULL),
        ns(NULL),
        fcProp(NULL),
        ready(false),
        useGps(true),
        nErrors(0),
        minMsBeforeNewRequest(baseMsBeforeNewRequest)
    {
        delayedCityRequestTimer.setSingleShot(true);
        delayedCityRequestTimer.setInterval(1000); // 1 s
        requestNewWeatherTimer.setSingleShot(false);
        requestNewWeatherTimer.setInterval(20*60*1000); // 20 min
        throttle.invalidate();
        app_ident = QStringLiteral("c64cfa1dcc241bd87441132104bb5e48");
    }
};

static void forecastAppend(QQmlListProperty<WeatherData> *prop, WeatherData *val)
{
    Q_UNUSED(val);
    Q_UNUSED(prop);
}

static WeatherData *forecastAt(QQmlListProperty<WeatherData> *prop, int index)
{
    AppModelPrivate *d = static_cast<AppModelPrivate*>(prop->data);
    return d->forecast.at(index);
}

static int forecastCount(QQmlListProperty<WeatherData> *prop)
{
    AppModelPrivate *d = static_cast<AppModelPrivate*>(prop->data);
    return d->forecast.size();
}

static void forecastClear(QQmlListProperty<WeatherData> *prop)
{
    static_cast<AppModelPrivate*>(prop->data)->forecast.clear();
}

AppModel::AppModel(QObject *parent) :
    QObject(parent),
    d(new AppModelPrivate)
{
    d->fcProp = new QQmlListProperty<WeatherData>(this, d,
                                                  forecastAppend,
                                                  forecastCount,
                                                  forecastAt,
                                                  forecastClear);

    connect(&d->delayedCityRequestTimer, SIGNAL(timeout()),
            this, SLOT(queryCity()));
    connect(&d->requestNewWeatherTimer, SIGNAL(timeout()),
            this, SLOT(refreshWeather()));
    d->requestNewWeatherTimer.start();

    // make sure we have an active network session
    d->nam = new QNetworkAccessManager(this);

    QNetworkConfigurationManager ncm;
    d->ns = new QNetworkSession(ncm.defaultConfiguration(), this);
    connect(d->ns, SIGNAL(opened()), this, SLOT(networkSessionOpened()));
    // the session may be already open. if it is, run the slot directly
    if (d->ns->isOpen())
        this->networkSessionOpened();
    // tell the system we want network
    d->ns->open();
}

AppModel::~AppModel()
{
    d->ns->close();
    if (d->src)
        d->src->stopUpdates();
    delete d;
}

void AppModel::networkSessionOpened()
{
    d->src = QGeoPositionInfoSource::createDefaultSource(this);

    if (d->src) {
        d->useGps = true;
        connect(d->src, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
        connect(d->src, SIGNAL(error(QGeoPositionInfoSource::Error)),
                this, SLOT(positionError(QGeoPositionInfoSource::Error)));
        d->src->startUpdates();
    } else {
        d->useGps = false;
        d->city = "Brisbane";
        emit cityChanged();
        this->refreshWeather();
    }
}

void AppModel::positionUpdated(QGeoPositionInfo gpsPos)
{
    d->coord = gpsPos.coordinate();

    if (!(d->useGps))
        return;

    queryCity();
}

void AppModel::queryCity()
{
    //don't update more often then once a minute
    //to keep load on server low
    if (d->throttle.isValid() && d->throttle.elapsed() < d->minMsBeforeNewRequest ) {
        qCDebug(requestsLog) << "delaying query of city";
        if (!d->delayedCityRequestTimer.isActive())
            d->delayedCityRequestTimer.start();
        return;
    }
    qDebug(requestsLog) << "requested query of city";
    d->throttle.start();
    d->minMsBeforeNewRequest = (d->nErrors + 1) * d->baseMsBeforeNewRequest;

    QString latitude, longitude;
    longitude.setNum(d->coord.longitude());
    latitude.setNum(d->coord.latitude());

    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    QUrlQuery query;
    query.addQueryItem("lat", latitude);
    query.addQueryItem("lon", longitude);
    query.addQueryItem("mode", "json");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);
    qCDebug(requestsLog) << "submitting request";

    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleGeoNetworkData(rep); });
}

void AppModel::positionError(QGeoPositionInfoSource::Error e)
{
    Q_UNUSED(e);
    qWarning() << "Position source error. Falling back to simulation mode.";
    // cleanup insufficient QGeoPositionInfoSource instance
    d->src->stopUpdates();
    d->src->deleteLater();
    d->src = 0;

    // activate simulation mode
    d->useGps = false;
    d->city = "Gurugram";
    emit cityChanged();
    this->refreshWeather();
}

void AppModel::hadError(bool tryAgain)
{
    qCDebug(requestsLog) << "hadError, will " << (tryAgain ? "" : "not ") << "rety";
    d->throttle.start();
    if (d->nErrors < 10)
        ++d->nErrors;
    d->minMsBeforeNewRequest = (d->nErrors + 1) * d->baseMsBeforeNewRequest;
    if (tryAgain)
        d->delayedCityRequestTimer.start();
}

void AppModel::handleGeoNetworkData(QNetworkReply *networkReply)
{
    if (!networkReply) {
        hadError(false); // should retry?
        return;
    }

    if (!networkReply->error()) {
        d->nErrors = 0;
        if (!d->throttle.isValid())
            d->throttle.start();
        d->minMsBeforeNewRequest = d->baseMsBeforeNewRequest;
        //convert coordinates to city name
        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());

        QJsonObject jo = document.object();
        QJsonValue jv = jo.value(QStringLiteral("name"));

        const QString city = jv.toString();
        qCDebug(requestsLog) << "got city: " << city;
        if (city != d->city) {
            d->city = city;
            emit cityChanged();
            refreshWeather();
        }
    } else {
        hadError(true);
    }
    networkReply->deleteLater();
}

void AppModel::refreshWeather()
{
    if (d->city.isEmpty()) {
        qCDebug(requestsLog) << "refreshing weather skipped (no city)";
        return;
    }
    qCDebug(requestsLog) << "refreshing weather";
    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    QUrlQuery query;

    query.addQueryItem("q", d->city);
    query.addQueryItem("mode", "json");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);

    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleWeatherNetworkData(rep); });
}

static QString niceTemperatureString(double t)
{
    return QString::number(qRound(t-ZERO_KELVIN)) + QChar(0xB0);
}

void AppModel::handleWeatherNetworkData(QNetworkReply *networkReply)
{
    qCDebug(requestsLog) << "got weather network data";
    if (!networkReply)
        return;

    if (!networkReply->error()) {
        foreach (WeatherData *inf, d->forecast)
            delete inf;
        d->forecast.clear();

        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());

        if (document.isObject()) {
            QJsonObject obj = document.object();
            QJsonObject tempObject;
            QJsonValue val;
            QJsonValue min;
            QJsonValue max;

            qDebug()<<"Data We Received :: "<<obj;

            if (obj.contains(QStringLiteral("weather"))) {
                val = obj.value(QStringLiteral("weather"));
                QJsonArray weatherArray = val.toArray();
                val = weatherArray.at(0);
                tempObject = val.toObject();
                d->now.setWeatherDescription(tempObject.value(QStringLiteral("description")).toString());
                d->now.setWeatherIcon(tempObject.value("icon").toString());
            }
            if (obj.contains(QStringLiteral("main"))) {
                val = obj.value(QStringLiteral("main"));
                tempObject = val.toObject();
                val = tempObject.value(QStringLiteral("temp"));
                max = tempObject.value(QStringLiteral("temp_max"));
                min = tempObject.value(QStringLiteral("temp_min"));
                QString data;
                data = niceTemperatureString(max.toDouble());
//                data += QChar('/');
//                data += niceTemperatureString(min.toDouble());
                d->now.setTemperature(data);
                d->now.setMinTemperature(niceTemperatureString(min.toDouble()));
            }

            //get date
            val = obj.value(QStringLiteral("dt"));
            QDateTime dt = QDateTime::fromMSecsSinceEpoch((qint64)val.toDouble()*1000);
            QString date;
            date ="Today," + dt.date().toString(QStringLiteral("MMMM d"));
            d->now.setDayOfWeek(date);
        }
    }
    networkReply->deleteLater();

    //retrieve the forecast
    QUrl url("http://api.openweathermap.org/data/2.5/forecast/daily");
    QUrlQuery query;

    query.addQueryItem("q", d->city);
    query.addQueryItem("mode", "json");
    query.addQueryItem("cnt", "7");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);

    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleForecastNetworkData(rep); });
}

void AppModel::handleForecastNetworkData(QNetworkReply *networkReply)
{
    qCDebug(requestsLog) << "got forecast";
    if (!networkReply)
        return;

    if (!networkReply->error()) {
        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());

        QJsonObject jo;
        QJsonValue jv;
        QJsonObject root = document.object();
        jv = root.value(QStringLiteral("list"));
        if (!jv.isArray())
            qWarning() << "Invalid forecast object";
        QJsonArray ja = jv.toArray();
        //we need 7 days of forecast -> first entry is today
        if (ja.count() != 7)
            qWarning() << "Invalid forecast object";

        QString data;
        for (int i = 1; i<ja.count(); i++) {
            WeatherData *forecastEntry = new WeatherData();

            //min/max temperature
            QJsonObject subtree = ja.at(i).toObject();
            jo = subtree.value(QStringLiteral("temp")).toObject();
            jv = jo.value(QStringLiteral("max"));
            data.clear();
            data += niceTemperatureString(jv.toDouble());
//            data += QChar('/');
//            jv = jo.value(QStringLiteral("min"));
//            data += niceTemperatureString(jv.toDouble());
            forecastEntry->setTemperature(data);
            forecastEntry->setMinTemperature(niceTemperatureString(jv.toDouble()));
            //get date
            jv = subtree.value(QStringLiteral("dt"));
            QDateTime dt = QDateTime::fromMSecsSinceEpoch((qint64)jv.toDouble()*1000);
            if(i==1){
                forecastEntry->setDayOfWeek("Tomorrow");
            }else
            forecastEntry->setDayOfWeek(dt.date().toString(QStringLiteral("dddd")));

            //get icon
            QJsonArray weatherArray = subtree.value(QStringLiteral("weather")).toArray();
            jo = weatherArray.at(0).toObject();
            forecastEntry->setWeatherIcon(jo.value(QStringLiteral("icon")).toString());

            //get description
            forecastEntry->setWeatherDescription(jo.value(QStringLiteral("description")).toString());

            d->forecast.append(forecastEntry);
        }

        if (!(d->ready)) {
            d->ready = true;
            emit readyChanged();
        }

        emit weatherChanged();
    }
    networkReply->deleteLater();
}

bool AppModel::hasValidCity() const
{
    return (!(d->city.isEmpty()) && d->city.size() > 1 && d->city != "");
}

bool AppModel::hasValidWeather() const
{
    return hasValidCity() && (!(d->now.weatherIcon().isEmpty()) &&
                              (d->now.weatherIcon().size() > 1) &&
                              d->now.weatherIcon() != "");
}

WeatherData *AppModel::weather() const
{
    return &(d->now);
}

QQmlListProperty<WeatherData> AppModel::forecast() const
{
    return *(d->fcProp);
}

bool AppModel::ready() const
{
    return d->ready;
}

bool AppModel::hasSource() const
{
    return (d->src != NULL);
}

bool AppModel::useGps() const
{
    return d->useGps;
}

void AppModel::setUseGps(bool value)
{
    d->useGps = value;
    if (value) {
        d->city = "";
        d->throttle.invalidate();
        emit cityChanged();
        emit weatherChanged();
    }
    emit useGpsChanged();
}

QString AppModel::city() const
{
    return d->city;
}

void AppModel::setCity(const QString &value)
{
    d->city = value;
    emit cityChanged();
    refreshWeather();
}
