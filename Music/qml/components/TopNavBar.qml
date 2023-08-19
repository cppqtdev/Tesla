import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../components"

Item {
    id: root
    height: 40
    Layout.fillWidth: true

    signal backClicked()
    signal menuClicked()
    signal musicPlaylistClicked()

    Item{
        height: 40; width: 40
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        AppIcon
        {
            anchors.centerIn: parent
            icon: mainQmlApp.stackLayout.currentIndex === 0? "\uf060":"\uf03a"
            color: "white"
            size: 15
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: {
                if(mainQmlApp.stackLayout.currentIndex === 0)
                    root.backClicked()

                else
                    root.musicPlaylistClicked()
            }
        }
    }

    Item{
        height: 40; width: 40
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        AppIcon
        {
            anchors.centerIn: parent
            icon: "\uf142"
            color: "white"
            size: 15
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: mainQmlApp.menuPopup.open()
        }
    }
}
