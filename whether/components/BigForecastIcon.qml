import QtQuick 2.0

Rectangle {
    id: current
    color: "#03A9F4"

    property string topText: "20*"
    property string minText: "20*"
    property string bottomText: "Mostly cloudy"
    property string weatherIcon: "01d"
    property string dateText: "Today"
    property real smallSide: (current.width < current.height ? current.width : current.height)


    Text {
        id:cityName
        anchors.topMargin: 5
        anchors.horizontalCenter:  parent.horizontalCenter
        text: (model.hasValidCity ? model.city : "Unknown location") + (model.useGps ? "" : "")
        font.pointSize: 21
        wrapMode: Text.WordWrap
        color: "#EEEEEE"
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
    Image{
        z:0
        width: parent.width *0.4
        height: parent.height *0.4
        source: "qrc:/Icons/28-white-clouds-png-image.png"
        anchors.centerIn: parent
    }

    Text {
        anchors.top: cityName.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter:  parent.horizontalCenter
        text: current.dateText
        font.pointSize: 21
        wrapMode: Text.WordWrap
        color: "#EEEEEE"
    }

    WeatherIcon {
        x: current.width/9
        y: current.height/4
        width: current.width/4
        weatherIcon: current.weatherIcon
        useServerIcon: false
        height: current.height/2

    }

    Text {
        x: current.width- current.width/3
        y: current.height/3
        text: current.topText
        opacity: 0.8
        font.pointSize: 50
        color: "#EEEEEE"
    }

    Text {
        x: current.width- current.width/3.5
        y: current.height-60
        text: current.minText
        opacity: 0.5
        font.pointSize: 30
        color: "#EEEEEE"
    }


    Text {
        x: current.width/8
        y: current.height-40
        width: current.width/2
        text: current.bottomText
        font.capitalization: Font.Capitalize
        font.pointSize: 18
        wrapMode: Text.WordWrap
        opacity: 0.5
        color: "#EEEEEE"
    }

}
