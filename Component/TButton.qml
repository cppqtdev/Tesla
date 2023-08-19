import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import Theme 1.0
Button {
    id: control
    property string setIcon : ""
    property bool isGlow: false

    font.pixelSize: 20
    font.family: "Montserrat"
    implicitHeight: 60
    implicitWidth: 150

    Image{
        source: setIcon
        scale: control.pressed ? 0.9 : 1.0
        Behavior on scale { NumberAnimation { duration: 200; } }
        anchors.centerIn: parent
    }
    contentItem:ColumnLayout{
        visible: !setIcon
        width: parent.width
        height: parent.height
        Label {
            text: control.text
            font:control.font
            color: Theme.fontColor
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }
    }

    background: Rectangle {
        implicitWidth: control.width
        implicitHeight: control.height
        radius: height / 2
        opacity: control.enabled ? 1 : 0.6
        color: Theme.isDarkMode ? "grey" : "#FFFFFF"
        Behavior on color {
            ColorAnimation {
                duration: 200;
                easing.type: Easing.Linear;
            }
        }

        Rectangle {
            id: indicator
            property int mx
            property int my
            x: mx - width / 2
            y: my - height / 2
            height: width
            radius: width / 2
            color: isGlow ? Qt.lighter("#29BEB6") : Qt.lighter("#B8FF01")
        }
    }

    Rectangle {
        id: mask
        radius: width
        anchors.fill: parent
        visible: false
    }

    OpacityMask {
        anchors.fill: background
        source: background
        opacity: 0.4
        maskSource: mask
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
    }

    ParallelAnimation {
        id: anim
        NumberAnimation {
            target: indicator
            property: 'width'
            from: 0
            to: control.width * 1.5
            duration: 200
        }
        NumberAnimation {
            target: indicator;
            property: 'opacity'
            from: 0.9
            to: 0
            duration: 200
        }
    }

    onPressed: {
        indicator.mx = mouseArea.mouseX
        indicator.my = mouseArea.mouseY
        anim.restart();
    }
}
