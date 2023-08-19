import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../"

import Theme 1.0
Item {

    ColumnLayout{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 40
        anchors.topMargin: 40
        spacing: 50

        ColumnLayout{
            spacing: 10
            Label {
                text: "Steering Mode"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["Comfort" ,"Standard","Sport"]
            }
            Label {
                text: "Regenerative Braking"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["Standard" ,"Low"]
            }
            Label {
                text: "Standard increases range and extends battery life"
                Layout.fillWidth: true
                font.pixelSize: 16
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }

        ColumnLayout{
            spacing: 10
            Label {
                text: "Traction Control"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            TButton{
               implicitWidth: 220
               implicitHeight: 60
               text: qsTr("Slip Start")
            }

            Label {
                text: "Used to help vehicle stuck in sand, snow, or mud"
                Layout.fillWidth: true
                font.pixelSize: 16
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
            TButton{
               implicitWidth: 220
               implicitHeight: 60
               text: qsTr("Creep")
            }

            Label {
                text: "Slowly move forward when the brake pedal is released"
                Layout.fillWidth: true
                font.pixelSize: 16
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }

    }
}
