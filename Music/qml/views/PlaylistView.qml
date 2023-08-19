import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import Qt.labs.platform 1.0
import "../components"
import "../delegates"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5

    function loadAudio()
    {
        musicModel.clear()
        var musicList = QmlInterface.getAllAudioFiles()

        //console.log(">> ", musicList)
        console.log("Music List :: ",JSON.stringify(musicList))

        for(var i = 0; i<musicList.length; i++)
        {
            //console.log("--> ", musicList[i])

            musicModel.append({"_no":i+1, "_title":musicList[i], "_length":"03.20"});
        }

        mainQmlApp.updateTitles()
    }

    Component.onCompleted: loadAudio()

    Component
    {
        id: musicDelegate

        MusicDelegate{
            no: _no
            musictitle: _title
            musiclength: _length
            isCurrentlySelected: index === mainQmlApp.currentMusicIndex

            onClicked: {
                listView.currentIndex = index

                mainQmlApp.currentMusicIndex=listView.currentIndex
            }

            onMenuClicked: {
                clickedIndex = index

                console.log(index)

                var globalCoord = mouseArea.mapToItem(root, 0, 0)
                // taskOptionsPopupX = globalCoord.x
                mainQmlApp.yCoordinate = globalCoord.y


                mainQmlApp.menuDelegatePopup.open()
            }
        }
    }

    FolderDialog {
        id: folderDialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]

        onAccepted: {

            QmlInterface.setMusicPath(folder);

            loadAudio()
        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        TopNavBar
        {
            onBackClicked: mainQmlApp.stackLayout.currentIndex=1
            onMusicPlaylistClicked: mainQmlApp.stackLayout.currentIndex=0
            onMenuClicked: {}
        }

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: musicIcon.height+4

            Rectangle
            {
                id: musicIcon
                width: root.width/2; height: width; radius: width/2; color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                border.width: 5; border.color: "#5d7ec3"

                Rectangle{
                    width: parent.width-30; height: width; radius: height/2
                    color: "#3f5471"; anchors.centerIn: parent; clip: true

                    AppIcon
                    {
                        anchors.centerIn: parent
                        icon: "\uf025"; color: "#516b8e"
                        size: 0.75*parent.width
                    }
                }
            }
        }

        Text
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"; font.pixelSize: 18
            text: qsTr("Unknown Album")
        }

        Text
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: mainQmlApp.foreColor; font.pixelSize: 14
            text: artistName.length>20? artistName.slice(0,19)+"...":artistName
        }

        Item
        {
            Layout.preferredHeight: 30
            Layout.preferredWidth: 130
            Layout.alignment: Qt.AlignHCenter

            Rectangle
            {
                color: "#5d7ec3"; width: 90
                height: 28; radius: height/2
                anchors.left: parent.left
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                AppIcon
                {
                    anchors.left: parent.left; anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    icon: !mainQmlApp.isMusicPlaying? "\uf04b":"\uf04c"; size: 15; color: mainQmlApp.darkThemeColor
                }

                Text
                {
                    color: mainQmlApp.darkThemeColor; font.pixelSize: 12
                    text: !mainQmlApp.isMusicPlaying? qsTr("Listen"):qsTr("Pause"); font.bold: true
                    anchors.right: parent.right; anchors.rightMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        if(mainQmlApp.musicModel.rowCount()>0)
                        {
                            mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                        }
                    }
                }
            }

            Rectangle
            {
                color: mainQmlApp.foreColor
                width: 28; height: width; radius: height/2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                AppIcon
                {
                    anchors.centerIn: parent
                    icon: "\uf067"; size: 15; color: mainQmlApp.darkThemeColor
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: folderDialog.open()
                }


            }
        }

        ScrollView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.interactive: true
            clip: true

            ListView
            {
                id: listView
                anchors.fill: parent
                model: mainQmlApp.musicModel
                delegate: musicDelegate
            }
        }

        Item{
            visible: mainQmlApp.isMusicPlaying
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            Rectangle
            {
                height: 2; width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top; color: "#5d7ec3"
            }

            Item
            {
                anchors.left: parent.left; anchors.right: pauseBtn.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10; anchors.rightMargin: 10
                height: 30; width: 30; clip: true

                ColumnLayout
                {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text
                    {
                        id: titleLabel
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: mainQmlApp.foreColor; font.pixelSize: 12
                        text: musicTitle_.length>40? musicTitle_.slice(0,40)+"...":musicTitle_
                    }

                    Text
                    {
                        id: authorLabel
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: mainQmlApp.foreColor; font.pixelSize: 10
                        text: artistName
                    }
                }
            }

            Item
            {
                id: pauseBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                height: 30; width: 30

                AppIcon
                {
                    anchors.centerIn: parent
                    icon: mainQmlApp.isMusicPlaying? "\uf04c":"\uf04b"; size: 20
                    color: "#5d7ec3"
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                }
            }
        }
    }
}
