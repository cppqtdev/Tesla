import QtQuick 2.0

Item {
    id: container

    property string weatherIcon: "01d"

    //server icons are too small. we keep using the local images
    property bool useServerIcon: true

    Image {
        id: img
        source: {
            if (useServerIcon)
                "http://openweathermap.org/img/w/" + container.weatherIcon + ".png"
            else {
                switch (weatherIcon) {
                case "01d":
                case "01n":
                    "../icons/weather-sunny.png"
                    break;
                case "02d":
                case "02n":
                    "../icons/weather-sunny-very-few-clouds.png"
                    break;
                case "03d":
                case "03n":
                    "../icons/weather-few-clouds.png"
                    break;
                case "04d":
                case "04n":
                    "../icons/weather-overcast.png"
                    break;
                case "09d":
                case "09n":
                    "../icons/weather-showers.png"
                    break;
                case "10d":
                case "10n":
                    "../icons/weather-showers.png"
                    break;
                case "11d":
                case "11n":
                    "../icons/weather-thundershower.png"
                    break;
                case "13d":
                case "13n":
                    "../icons/weather-snow.png"
                    break;
                case "50d":
                case "50n":
                    "../icons/weather-fog.png"
                    break;
                default:
                    "../icons/weather-unknown.png"
                }
            }
        }
        smooth: true
        anchors.fill: parent

    }
}
