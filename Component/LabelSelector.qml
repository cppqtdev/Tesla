import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

import Theme 1.0


Pane{
    id:control
    padding: 0
    leftInset: 0
    rightInset: 0
    property string setColors: Theme.isDarkMode ? "grey" : "#FFFFFF"
    property real radius: implicitHeight / 2
    property int allowMaxTags: 5
    property var lableList: ["Lable","Lable","Lable"]
    implicitWidth: layout.implicitWidth
    implicitHeight: 60

    background: Rectangle{
        implicitHeight: control.implicitHeight
        implicitWidth: control.implicitWidth
        color: Theme.isDarkMode ? "#1c1d21" : "Grey"
        radius: control.radius
    }

    RowLayout{
        id:layout
        spacing: 0
        anchors{
            verticalCenter: parent.verticalCenter
        }

        Repeater {
            id:rep
            Layout.alignment: Qt.AlignHCenter
            width: parent.width
            model: lableList

            delegate: RadioButton {
                id: labelIndicator
                padding: 0
                checked: index === 0
                indicator: Item{ }

                contentItem: Rectangle{
                    implicitHeight: control.implicitHeight - 1
                    implicitWidth: tags.implicitWidth + 106
                    radius: control.radius
                    color: labelIndicator.checked ? setColors : "transparent"

                    HoverHandler{
                        id: tagHovered
                    }

                    Label {
                        id:tags
                        text: modelData
                        font.pixelSize: 20
                        font.family: "Montserrat"
                        color: Theme.fontColor
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
