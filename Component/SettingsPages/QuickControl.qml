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
        spacing: 50

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
        }

        ColumnLayout{
            spacing: 10
            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                IconButton{
                    setIcon: !Theme.isDarkMode ? "qrc:/Icons/headlights-small_dark.svg" : "qrc:/Icons/headlights-small.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Exterior Lights"
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
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

        ColumnLayout{
            spacing: 10
            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                IconButton{
                    setIcon: !Theme.isDarkMode ? "qrc:/Icons/adjustments_dark.svg" : "qrc:/Icons/adjustments.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Adjustments"
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }

            RowLayout{
                spacing: 30
                Rectangle{
                    height: 117
                    width: 330
                    radius: 50
                    color: Theme.isDarkMode ? "grey" : "#FFFFFF"
                    ColumnLayout{
                        spacing: 10
                        anchors.centerIn: parent
                        RowLayout{
                            Layout.alignment: Qt.AlignHCenter
                            IconButton{
                                setIcon: !Theme.isDarkMode ? "qrc:/Icons/mirror_dark.svg" : "qrc:/Icons/mirror.svg"
                            }

                            IconButton{
                                isMirror: true
                                setIcon: !Theme.isDarkMode ? "qrc:/Icons/mirror_dark.svg" : "qrc:/Icons/mirror.svg"
                            }
                        }

                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Mirrors"
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
                        spacing: 10
                        IconButton{
                            Layout.alignment: Qt.AlignHCenter
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/Settings/steering wheel-small.svg" : "qrc:/Icons/Settings/light/steering wheel-small.svg"
                        }

                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Steering Wheel"
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            color: Theme.fontColor
                        }
                    }
                }
            }

            TButton{
               implicitWidth: 220
               implicitHeight: 60
               text: qsTr("Fold Mirrors")
            }
        }

    }
}
