import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import Theme 1.0

TextField {
    id: control
    property bool isBold: true
    property real radius: 12.0
    property string setIcon: ""
    property alias icon: icon
    opacity: 0.8
    focus: true
    implicitWidth: 340
    implicitHeight: 70
    placeholderText: qsTr("Navigation")
    placeholderTextColor: Qt.lighter(Theme.fontColor)
    selectedTextColor: "#1ca254"
    selectionColor: "#305e4b"
    font.pixelSize: 24
    font.family: "Montserrat"
    font.bold: isBold ? Font.DemiBold : Font.Normal
    font.weight: isBold ? Font.DemiBold : Font.Normal
    color: Theme.fontColor
    verticalAlignment: Qt.AlignVCenter

    Image{
        id:icon
        source: setIcon
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle{
        implicitHeight: control.implicitHeight
        implicitWidth: control.implicitWidth
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.background
        radius: control.radius
    }
}
