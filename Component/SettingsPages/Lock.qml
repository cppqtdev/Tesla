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

        RowLayout{
            spacing: 10
            TSwitch{
                checkedColor: "#228BE6"
                checked: true
            }

            Label {
                text: "Walk Up Unlock"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }
        RowLayout{
            spacing: 10
            TSwitch{
                checkedColor: "#228BE6"
                checked: false
            }

            Label {
                text: "Walk Away Unlock"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }
        RowLayout{
            spacing: 10
            TSwitch{
                checkedColor: "#228BE6"
                checked: true
            }

            Label {
                text: "Child Protection Lock"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }
        RowLayout{
            spacing: 10
            TSwitch{
                checkedColor: "#228BE6"
                checked: false
            }

            Label {
                text: "Unlock on Park"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }
        }

    }
}
