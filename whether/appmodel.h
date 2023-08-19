#ifndef APPMODEL_H
#define APPMODEL_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtNetwork/QNetworkReply>
#include <QtQml/QQmlListProperty>

#include <QtPositioning/QGeoPositionInfoSource>

class WeatherData : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString dayOfWeek
               READ dayOfWeek WRITE setDayOfWeek
               NOTIFY dataChanged)
    Q_PROPERTY(QString weatherIcon
               READ weatherIcon WRITE setWeatherIcon
               NOTIFY dataChanged)
    Q_PROPERTY(QString weatherDescription
               READ weatherDescription WRITE setWeatherDescription
               NOTIFY dataChanged)
    Q_PROPERTY(QString temperature
               READ temperature WRITE setTemperature
               NOTIFY dataChanged)
    Q_PROPERTY(QString minTemperature
               READ minTemperature WRITE setMinTemperature
               NOTIFY dataChanged)

public:
    explicit WeatherData(QObject *parent = 0);
    WeatherData(const WeatherData &other);

    QString dayOfWeek() const;
    QString weatherIcon() const;
    QString weatherDescription() const;
    QString temperature() const;
    QString minTemperature() const;

    void setDayOfWeek(const QString &value);
    void setWeatherIcon(const QString &value);
    void setWeatherDescription(const QString &value);
    void setTemperature(const QString &value);
    void setMinTemperature(const QString &value);

signals:
    void dataChanged();
private:
    QString m_dayOfWeek;
    QString m_weather;
    QString m_weatherDescription;
    QString m_temperature;
    QString m_minTemperature;
};

Q_DECLARE_METATYPE(WeatherData)

class AppModelPrivate;
class AppModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool ready
               READ ready
               NOTIFY readyChanged)
    Q_PROPERTY(bool hasSource
               READ hasSource
               NOTIFY readyChanged)
    Q_PROPERTY(bool hasValidCity
               READ hasValidCity
               NOTIFY cityChanged)
    Q_PROPERTY(bool hasValidWeather
               READ hasValidWeather
               NOTIFY weatherChanged)
    Q_PROPERTY(bool useGps
               READ useGps WRITE setUseGps
               NOTIFY useGpsChanged)
    Q_PROPERTY(QString city
               READ city WRITE setCity
               NOTIFY cityChanged)
    Q_PROPERTY(WeatherData *weather
               READ weather
               NOTIFY weatherChanged)
    Q_PROPERTY(QQmlListProperty<WeatherData> forecast
               READ forecast
               NOTIFY weatherChanged)

public:
    explicit AppModel(QObject *parent = 0);
    ~AppModel();

    bool ready() const;
    bool hasSource() const;
    bool useGps() const;
    bool hasValidCity() const;
    bool hasValidWeather() const;
    void setUseGps(bool value);
    void hadError(bool tryAgain);

    QString city() const;
    void setCity(const QString &value);

    WeatherData *weather() const;
    QQmlListProperty<WeatherData> forecast() const;

public slots:
    Q_INVOKABLE void refreshWeather();

private slots:
    void queryCity();
    void networkSessionOpened();
    void positionUpdated(QGeoPositionInfo gpsPos);
    void positionError(QGeoPositionInfoSource::Error e);
    void handleGeoNetworkData(QNetworkReply *networkReply);
    void handleWeatherNetworkData(QNetworkReply *networkReply);
    void handleForecastNetworkData(QNetworkReply *networkReply);

signals:
    void readyChanged();
    void useGpsChanged();
    void cityChanged();
    void weatherChanged();


private:
    AppModelPrivate *d;

};

#endif // APPMODEL_H
