import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "../components"
import "../delegates"
import Theme 1.0
Item {
    id: root
    anchors.fill: parent
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

    RotationAnimator {
        loops: Animation.Infinite
        target: rotatingIcon;
        from: 0;
        to: 360;
        duration: 3000
        running: mainQmlApp.isMusicPlaying
    }

    ColumnLayout{
        anchors.fill: parent
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
        }

        Item
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 70

            RowLayout
            {
                width: parent.width
                anchors.centerIn: parent
                anchors.margins: 20
                spacing: 10

                Item{
                    // Shuffle
                    height: 40; width: 40

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
                    height: 40; width: 40

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
                    height: 40; width: 40

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


                Item{
                    // Repeat
                    height: 40; width: 40

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
