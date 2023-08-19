#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QIcon>
#include<teslasettings.h>
#include<svgimageprovider.h>
#include "Music/cpp/radialbar.h"
#include "Music/cpp/qmlinterface.h"
#include "whether/appmodel.h"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    app.setApplicationName("Tesla Organization");
    app.setApplicationDisplayName("Tesla");
    app.setOrganizationName("Tesla");
    app.setApplicationVersion("1.0");
    QIcon icon(":/Icons/black/Tesla Logo.svg");
    app.setWindowIcon(icon);

    QQmlApplicationEngine engine;
    TeslaSettings _tesla_settings;
    engine.rootContext()->setContextProperty("cSettings",&_tesla_settings);
    qmlRegisterSingletonType(QUrl("qrc:/Theme.qml"), "Theme", 1, 0, "Theme");

    SvgImageProvider *imageProvider = new SvgImageProvider();
    engine.addImageProvider(QLatin1String("svg_icon_color_change"), imageProvider);


    QmlInterface * qmlInterface = new QmlInterface(&app, &engine);
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    engine.rootContext()->setContextProperty(QStringLiteral("QmlInterface"),qmlInterface);

    qmlRegisterType<WeatherData>("WeatherInfo", 1, 0, "WeatherData");
    qmlRegisterType<AppModel>("WeatherInfo", 1, 0, "AppModel");
    qRegisterMetaType<WeatherData>();

    const QUrl url(QStringLiteral(/*"qrc:/main.qml"*/"qrc:/Dashboard.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
