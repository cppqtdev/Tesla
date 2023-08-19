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
        spacing: 30

        Label {
            text: "Exterior"
            Layout.fillWidth: true
            font.pixelSize: 24
            font.bold: Font.Bold
            font.family: "Montserrat"
            verticalAlignment: Image.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
            color: Theme.fontColor
        }

        ColumnLayout{
            spacing: 10
            Label {
                text: "Headlights"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["On" ,"Off","Parking","Auto"]
            }
            TButton{
               implicitWidth: 220
               implicitHeight: 60
               text: qsTr("Front fog")
            }
        }

        Label {
            text: "Interior"
            Layout.fillWidth: true
            font.pixelSize: 24
            font.bold: Font.Bold
            font.family: "Montserrat"
            verticalAlignment: Image.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
            color: Theme.fontColor
        }

        ColumnLayout{
            spacing: 10
            Label {
                text: "Dome Lights"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["On" ,"Off","Auto"]
            }

            TButton{
               implicitWidth: 220
               implicitHeight: 60
               text: qsTr("Ambient Lights")
            }
        }

    }
}
