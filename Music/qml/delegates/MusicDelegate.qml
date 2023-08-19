import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../components"

Item {
    id: root
    height: 60
    width: parent.width

    property bool isCurrentlySelected: false
    property int no
    property string musictitle
    property string musiclength

    property alias mouseArea: mouseArea

    signal clicked()
    signal menuClicked()


    RotationAnimator {
        target: rotatingIcon;
        loops: Animation.Infinite
        from: 0;
        to: 360;
        duration: 3000
        running: mainQmlApp.isMusicPlaying && isCurrentlySelected
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 3

        Text {
            text: no.toString()+"."
            font.pixelSize: 20
            Layout.leftMargin: 5
            Layout.minimumWidth: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            color: isCurrentlySelected? "#516b8e" :mainQmlApp.foreColor

            MouseArea
            {
                anchors.fill: parent
                onClicked: root.clicked()
            }
        }

        Item{
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.minimumWidth: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Text {
                text: musictitle
                font.pixelSize: 20
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: isCurrentlySelected? "#516b8e":mainQmlApp.foreColor
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: root.clicked()
            }
        }

        Text {
            visible: false //!(mainQmlApp.isMusicPlaying && isCurrentlySelected)
            text: musiclength
            Layout.minimumWidth: 50
            font.pixelSize: 20
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            color: isCurrentlySelected? "#516b8e":mainQmlApp.foreColor

            MouseArea
            {
                anchors.fill: parent
                onClicked: root.clicked()
            }
        }

        Item
        {
            height: 30; width: 50
            visible: mainQmlApp.isMusicPlaying && isCurrentlySelected
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft

            AppIcon
            {
                id: rotatingIcon
                size: 15
                color: isCurrentlySelected? "#516b8e":mainQmlApp.foreColor
                anchors.centerIn: parent
                icon: "\uf51f"
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: root.clicked()
            }
        }


        Item
        {
            height: 30; width: 30
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            Layout.rightMargin: 5

            AppIcon
            {

                id: mouseArea
                size: 15
                color: isCurrentlySelected? "#516b8e":mainQmlApp.foreColor
                anchors.centerIn: parent
                icon: "\uf142"
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked ...")
                    root.menuClicked()
                }
            }
        }
    }
}
