
import QtQuick 2.0
import "components"
import WeatherInfo 1.0

Rectangle {
    id: window
    width: 360
    height: 640
    border.color: "#90CAF9"
    border.width: 2
    color: "transparent"

    state: "loading"

    states: [
        State {
            name: "loading"
            PropertyChanges { target: main; opacity: 0 }
            PropertyChanges { target: wait; opacity: 1 }
        },
        State {
            name: "ready"
            PropertyChanges { target: main; opacity: 1 }
            PropertyChanges { target: wait; opacity: 0 }
        }
    ]
    AppModel {
        id: model
        onReadyChanged: {
            if (model.ready)
                window.state = "ready"
            else
                window.state = "loading"
        }
    }
    Item {
        id: wait
        anchors.fill: parent

        Text {
            text: "Loading weather data..."
            anchors.centerIn: parent
            font.pointSize: 18
        }
    }

    Rectangle {
        id: main
        anchors.fill: parent
        color: "#90CAF9"

        Column {

            anchors {
                fill: parent
                topMargin: 6; bottomMargin: 6; leftMargin: 6; rightMargin: 6
            }

            Rectangle {
                width: parent.width
                height: 25
                color: "#03A9F4"

                Text {
                    text: (model.hasValidCity ? model.city : "Unknown location") + (model.useGps ? "" : "")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (model.useGps) {
                            model.useGps = false
                            model.city = "Brisbane"
                        } else {
                            switch (model.city) {
                            case "Brisbane":
                                model.city = "Oslo"
                                break
                            case "Oslo":
                                model.city = "Helsinki"
                                break
                            case "Helsinki":
                                model.city = "New York"
                                break
                            case "New York":
                                model.useGps = true
                                break
                            }
                        }
                    }
                }
            }

            BigForecastIcon {
                id: current

                width: main.width-12
                height: main.height/3

                weatherIcon: (model.hasValidWeather
                              ? model.weather.weatherIcon
                              : "01d")
                topText: (model.hasValidWeather
                          ? model.weather.temperature
                          : "??")
                minText: (model.hasValidWeather
                          ? model.weather.minTemperature
                          : "??")
                bottomText: (model.hasValidWeather
                             ? model.weather.weatherDescription
                             : "No weather data")
                dateText: (model.hasValidWeather ?
                               model.weather.dayOfWeek : "??")

                MouseArea {
                    height: 120
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 49
                    anchors.leftMargin: 0
                    anchors.topMargin: -49
                    anchors.fill: parent
                    onClicked: {
                        model.refreshWeather()
                    }
                }
                Component.onCompleted: {
                    console.log("Wether Info  ::",JSON.stringify(model.weather))
                }
            }

//            Rectangle {
//                id: iconRow

//                width: main.width-12
//                height: 2*main.height/3-12

//                property real iconWidth: iconRow.width/5
//                property real iconHeight: iconRow.height/12

//                ForecastIcon {
//                    id: forecast1
//                    y: 10
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[0].weatherIcon : "01d")
//                    topText: (model.hasValidWeather ?
//                                  model.forecast[0].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[0].temperature : "??/??")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[0].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")


//                }
//                ForecastIcon {
//                    id: forecast2
//                    y: iconRow.height/6
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    topText: (model.hasValidWeather ?
//                                  model.forecast[1].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[1].temperature : "??/??")
//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[1].weatherIcon : "01d")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[1].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")
//                }
//                ForecastIcon {
//                    id: forecast3
//                    y: 2*iconRow.height/6
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    topText: (model.hasValidWeather ?
//                                  model.forecast[2].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[2].temperature : "??/??")
//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[2].weatherIcon : "01d")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[2].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")
//                }
//                ForecastIcon {
//                    id: forecast4
//                    y: 3*iconRow.height/6
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    topText: (model.hasValidWeather ?
//                                  model.forecast[3].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[3].temperature : "??/??")
//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[3].weatherIcon : "01d")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[3].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")
//                }
//                ForecastIcon {
//                    id: forecast5
//                    y: 4*iconRow.height/6
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    topText: (model.hasValidWeather ?
//                                  model.forecast[4].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[4].temperature : "??/??")
//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[4].weatherIcon : "01d")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[4].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")
//                }

//                ForecastIcon {
//                    id: forecast6
//                    y: 5*iconRow.height/6
//                    width: iconRow.iconWidth
//                    height: iconRow.iconHeight

//                    topText: (model.hasValidWeather ?
//                                  model.forecast[4].dayOfWeek : "??")
//                    bottomText: (model.hasValidWeather ?
//                                     model.forecast[4].temperature : "??/??")
//                    weatherIcon: (model.hasValidWeather ?
//                                      model.forecast[4].weatherIcon : "01d")
//                    despText: (model.hasValidWeather
//                               ? model.forecast[4].weatherDescription
//                               : "No weather data")
//                    minText: (model.hasValidWeather
//                              ? model.weather.minTemperature
//                              : "??")
//                }

//            }

        }
    }
}
