#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickItem>
#include <QLoggingCategory>

#include "appmodel.h"

int main(int argc, char *argv[])
{
    QLoggingCategory::setFilterRules("wapp.*.debug=false");
    QGuiApplication application(argc, argv);

    qmlRegisterType<WeatherData>("WeatherInfo", 1, 0, "WeatherData");
    qmlRegisterType<AppModel>("WeatherInfo", 1, 0, "AppModel");

    qRegisterMetaType<WeatherData>();
    const QString mainQmlApp = QStringLiteral("qrc:///weatherinfo.qml");
    QQuickView view;
    view.setSource(QUrl(mainQmlApp));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setIcon(QIcon(":icons/ic_launcher.png"));

    QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));
    view.setGeometry(QRect(100, 100, 360, 640));
    view.show();
    return application.exec();
}
