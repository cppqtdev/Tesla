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
        spacing: 30

        Label {
            text: "Visibility"
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
                text: "Display Mode"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["Day" ,"Night","Auto"]
            }
        }

        ColumnLayout{
            spacing: 10
            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                IconButton{
                    setIcon: !Theme.isDarkMode ? "qrc:/Icons/display_dark.svg" : "qrc:/Icons/display.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Display Brightness"
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }

            TSlider{
                width: 680
                height: 60
                checkedColor: Theme.isDarkMode ? "grey" : "#FFFFFF"
                from:0
                to:100
                stepSize: 1
                value: 10
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Reduce brightness to conserve energy"
                Layout.fillWidth: true
                opacity: 0.8
                font.pixelSize: 16
                font.family: "Montserrat"
                color: Theme.fontColor
            }
        }

        Label {
            text: "Units & Format"
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
                text: "Distance"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["Kilometers" ,"Miles"]
            }
        }
        ColumnLayout{
            spacing: 10
            Label {
                text: "Temperature"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                verticalAlignment: Image.AlignVCenter
                Layout.alignment: Qt.AlignVCenter
                color: Theme.fontColor
            }

            LabelSelector{
                lableList:  ["ºF" ,"ºC"]
            }
        }

    }
}
