import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import Theme 1.0
ItemDelegate {
    id:root
    property string iconRectColor: ""
    property string lightIconRectIcon: ""
    property string darkIconRectIcon: ""
    property bool textColorWhite: false
    highlighted: ListView.isCurrentItem
    height: 50
    hoverEnabled: true
    focus: true

    background: Rectangle{
        color: "transparent"
        anchors.fill: parent
        radius: 8
    }

    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        width: parent.width
        height: parent.height
        anchors.fill: parent
        spacing: 20
        Layout.leftMargin: 10
        Layout.rightMargin: 10

        Rectangle{
            width: parent.height * 0.7
            height: parent.height * 0.7
            color: iconRectColor
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 10
            radius: 8

            Image{
                opacity: root.highlighted  ? 1 : 0.6
                source: Theme.isDarkMode ? lightIconRectIcon : darkIconRectIcon
                anchors.centerIn: parent
            }
        }

        Label {
            opacity: root.highlighted  ? 1 : 0.6
            text: name
            Layout.fillWidth: true
            font.pixelSize: 20
            font.family: "Montserrat"
            verticalAlignment: Image.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
            color: Theme.fontColor
        }
    }
}
