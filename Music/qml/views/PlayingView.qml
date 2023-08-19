import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "../components"
import "../delegates"
import Theme 1.0
Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5
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
                mainQmlApp.currentMusicIndex = listView.currentIndex
                mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                mainQmlApp.isMusicPlaying  = true
            }

            onMenuClicked: {
                clickedIndex = index
                var globalCoord = mouseArea.mapToItem(root, 0, 0)
                mainQmlApp.yCoordinate = globalCoord.y
                mainQmlApp.menuDelegatePopup.open()
            }
        }
    }

    signal size(bool max)

    RotationAnimator {
        loops: Animation.Infinite
        target: rotatingIcon;
        from: 0;
        to: 360;
        duration: 3000
        running: mainQmlApp.isMusicPlaying
    }

    ColumnLayout
    {
        anchors.fill: parent
        RowLayout{
            Layout.preferredHeight: 166
            Layout.minimumHeight: 166
            Layout.maximumHeight: 166
            Layout.leftMargin: 30
            Layout.rightMargin: 30
            spacing: 30
            ColumnLayout{
                Layout.fillWidth: true
                RowLayout{
                    Layout.leftMargin: 30
                    Layout.rightMargin: 10
                    spacing: 30
                    Layout.fillWidth: true
                    width: parent.width
                    Rectangle{
                        id: musicIcon
                        width: 50;
                        height: width;
                        radius: width/2;
                        color: mainQmlApp.foreColor

                        AppIcon{
                            id: rotatingIcon;
                            anchors.centerIn: parent
                            icon: "\uf51f";
                            color: "#516b8e"
                            size: 32
                        }

                        RoundProgressBar{
                            width: 70
                            anchors.centerIn: parent
                            progressColor: mainQmlApp.foreColor
                            foregroundColor: "#47689e"
                            dialWidth: 5
                            showText: false
                            startAngle: 0
                            spanAngle:360
                            value: playerDuration === 0? 0:(playerPosition * 100)/playerDuration
                        }
                    }

                    ColumnLayout{
                        Layout.fillWidth: true
                        spacing: 5
                        Text{
                            id: txt
                            color: mainQmlApp.foreColor; font.pixelSize: 18
                            text: musicTitle_.length>35? musicTitle_.slice(0,35)+"...":musicTitle_
                        }

                        Text {
                            Layout.preferredHeight: 20
                            color: mainQmlApp.foreColor; font.pixelSize: 14
                            text: artistName
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        Item{
                            height: 40; width: 40
                            anchors.right: playpausebtn.left
                            anchors.rightMargin: 40
                            anchors.verticalCenter: parent.verticalCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf04a"
                                color: mainQmlApp.foreColor
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: { QmlInterface.playPrevious() }
                            }
                        }

                        Item{
                            id: playpausebtn
                            height: 40; width: 40
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: mainQmlApp.isMusicPlaying? "\uf04c":"\uf04b"
                                color: mainQmlApp.foreColor
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    if(!mainQmlApp.isMusicPlaying)
                                    {
                                        if(musicModel.count>0)
                                            mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                                    }
                                    else
                                        mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                                }
                            }
                        }

                        Item{
                            height: 40; width: 40
                            anchors.left: playpausebtn.right
                            anchors.leftMargin: 40
                            anchors.verticalCenter: parent.verticalCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf04e"
                                color: mainQmlApp.foreColor
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: { QmlInterface.playNext() }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        Item{
                            // Search
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf002"
                                color: mainQmlApp.isShuffleEnabled? "#516b8e":foreColor
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    //search implement
                                }
                            }
                        }

                        Item{
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: expand.max ? "\uf422" : "\uf31e"
                                color: foreColor
                                size: 25
                                visible: true
                            }

                            MouseArea
                            {
                                id:expand
                                property bool max: false
                                anchors.fill: parent
                                onClicked: {
                                    max = !max
                                    size(max)
                                }
                            }
                        }

                        Item{
                            // Close
                            height: 40; width: 40
                        }
                    }

                }

                Item
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Item{
                            // Shuffle
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf074"
                                color: mainQmlApp.isShuffleEnabled? "#516b8e":foreColor
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    mainQmlApp.isShuffleEnabled = !mainQmlApp.isShuffleEnabled
                                }
                            }
                        }

                        Item{
                            // Add to playlist
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf067"
                                color: foreColor
                                size: 25
                                visible: true
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {}
                            }
                        }

                        Item{
                            // delete
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: "\uf1f8"
                                color: foreColor
                                size: 25
                                //visible: false
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: { QmlInterface.removeFromPlaylist(currentMusicIndex) }
                            }
                        }


                        Item{
                            // Repeat
                            height: 40; width: 40
                            Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                            AppIcon
                            {
                                anchors.centerIn: parent
                                icon: mainQmlApp.repeatIndex === 1? "\uf366":"\uf364"
                                color: mainQmlApp.repeatIndex === 0? foreColor:"#516b8e"
                                size: 25
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    mainQmlApp.repeatIndex += 1
                                    if(mainQmlApp.repeatIndex === 3)
                                        mainQmlApp.repeatIndex = 0
                                }
                            }
                        }
                    }
                }

            }
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true
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
        }
    }
}
