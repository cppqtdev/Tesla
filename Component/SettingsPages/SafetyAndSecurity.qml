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

        ColumnLayout{
            spacing: 10
            Label {
                text: "Parking Brake"
                Layout.fillWidth: true
                font.pixelSize: 20
                font.family: "Montserrat"
                color: Theme.fontColor
            }

            RowLayout{
                spacing: 20
                Rectangle{
                    height: 117
                    width: 330
                    radius: 50
                    color: Theme.isDarkMode ? "grey" : "#FFFFFF"

                    ColumnLayout{
                        spacing: 5
                        anchors.centerIn: parent
                        RowLayout{
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 20
                            IconButton{
                                Layout.alignment: Qt.AlignHCenter
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/Parking Brake Icon_dark.svg" : "qrc:/Icons/Parking Brake Icon.svg"
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Parking Brake"
                                font.pixelSize: 20
                                font.family: "Montserrat"
                                color: Theme.fontColor
                            }
                        }

                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: "BRAKE IS OFF"
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            color: Theme.fontColor
                        }
                    }
                }
                Label {
                    Layout.maximumWidth: parent.width /2
                    Layout.rightMargin: 20
                    text: "Selecting park on the steering column will aslo set \nthe parking brake"
                    font.pixelSize: 20
                    font.family: "Montserrat"
                    color: Theme.fontColor
                }
            }
        }


        ColumnLayout{
            spacing: 20

            Label {
                text: "Vehicle Power"
                font.pixelSize: 20
                font.family: "Montserrat"
                color: Theme.fontColor
            }

            TButton{
                text: "Power Off"
            }

            Label {
                text: "Pressing the brake pedal will turn the car on again"
                font.pixelSize: 16
                opacity: 0.8
                font.family: "Montserrat"
                color: Theme.fontColor
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
