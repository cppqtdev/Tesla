import QtQuick 2.0

Item {
    id: top

    property string topText: "Monday"
    property string weatherIcon: "01d"
    property string despText: "Mostly cloudy"
    property string bottomText: "22*/23*"
    property string minText: "22"

    WeatherIcon {
        id: icon
        weatherIcon: top.weatherIcon

        property real side: {
            var h = 3 * top.height
            if (top.width < h)
                top.width;
            else
                h;
        }

        width: icon.side
        height: icon.side
        anchors.centerIn: parent
    }


    Text {
        id: dayText
        x: top.width+20
        y: top.height-40
        width: top.width
        text: top.topText
        font.pointSize: 15
    }

    Text {
        id: despText
        x: top.width+20
        y: top.height-20
        opacity: 0.6
        width: top.width
        text: top.despText
        font.capitalization: Font.Capitalize
        font.pointSize: 12
    }

    Text {
        id: tempText
        x: top.width+160
        opacity: 1
        font.pointSize: 26
        text: top.bottomText
    }

    Text {
        id: minText
        x: top.width+230
        text: top.minText
        opacity: 0.5
        font.pointSize: 26
    }
}
