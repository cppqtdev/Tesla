import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Popup {
    width: 100
    height: 200

    background: Rectangle
    {
        id: root
        color: mainQmlApp.darkThemeColor
        border{
            width: 1
            color: mainQmlApp.foreColor
        }
        radius: 3

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            Item
            {
                Layout.fillWidth: true; Layout.fillHeight: true
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: root.color
                border{
                    width: 1
                    color: mainQmlApp.foreColor
                }

                Text {
                    id: name
                    text: mainQmlApp.isMusicPlaying? qsTr("Pause"):qsTr("Play")
                    color: "grey"
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying; close()}
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: root.color
                border{
                    width: 1
                    color: mainQmlApp.foreColor
                }

                Text {
                    text: qsTr("Add Music")
                    color: "grey"
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: root.color
                border{
                    width: 1
                    color: mainQmlApp.foreColor
                }

                Text {
                    text: qsTr("Remove")
                    color: "grey"
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        QmlInterface.removeFromPlaylist(currentMusicIndex)
                        close()
                    }
                }
            }

            Rectangle
            {

                height: 1; Layout.fillWidth: true; color: mainQmlApp.foreColor
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: root.color
                border{
                    width: 1
                    color: mainQmlApp.foreColor
                }

                Text {
                    text: qsTr("Exit")
                    color: "grey"
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: mainQmlApp.close()
                }
            }

            Item
            {
                Layout.fillWidth: true; Layout.fillHeight: true
            }
        }
    }
}
