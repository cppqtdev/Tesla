import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../"
import "../../"
import Theme 1.0
Item {

    ColumnLayout{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 40
        anchors.topMargin: 40
        spacing: 40

        Rectangle{
            height: 60
            width: 400
            radius: 50
            color: Theme.isDarkMode ? "grey" : "#FFFFFF"

            RowLayout{
                anchors.centerIn: parent
                spacing: 20
                IconButton{
                    Layout.alignment: Qt.AlignHCenter
                    setIcon: !Theme.isDarkMode ? "qrc:/Icons/wiper_dark.svg" : "qrc:/Icons/wiper.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Wiper Service Mode"
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }
        }

        Rectangle{
            height: 117
            width: 330
            radius: 50
            color: Theme.isDarkMode ? "grey" : "#FFFFFF"

            ColumnLayout{
                anchors.centerIn: parent
                spacing: 5
                IconButton{
                    Layout.alignment: Qt.AlignHCenter
                    setIcon:!Theme.isDarkMode ? "qrc:/Icons/headlights-small_dark.svg" : "qrc:/Icons/headlights-small.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Adjust Headlights"
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }
        }

        Rectangle{
            height: 117
            width: 330
            radius: 50
            color: Theme.isDarkMode ? "grey" : "#FFFFFF"

            ColumnLayout{
                anchors.centerIn: parent
                spacing: 5
                IconButton{
                    Layout.alignment: Qt.AlignHCenter
                    setIcon: !Theme.isDarkMode ? "qrc:/Icons/headlights-small_dark.svg" : "qrc:/Icons/headlights-small.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Headlight Reset"
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }
        }
    }
}
