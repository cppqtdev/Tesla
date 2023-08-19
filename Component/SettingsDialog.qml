import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import QtQuick.Layouts 1.3
import GeneralMagic 2.0
import Theme 1.0
import "./"
import "./SettingsPages"
ApplicationWindow {
    id:root
    width: 1300
    height: 750
    minimumHeight: 750
    maximumHeight: 750
    minimumWidth: 1300
    maximumWidth: 1300
    flags: Qt.Dialog
    signal applyTheme(var mapInfo)

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Connections{
        target: mainStack.currentItem
        function onApplyTheme(mapInfo){
            root.applyTheme(mapInfo)
        }
    }

    Component{
        id:quickControl
        QuickControl{

        }
    }

    Component{
        id:autopilote
        Autopilote{

        }
    }

    Component{
        id:display
        Display{

        }
    }

    Component{
        id:driving
        Driving{

        }
    }

    Component{
        id:light
        Lights{

        }
    }

    Component{
        id:lock
        Lock{

        }
    }

    Component{
        id:safety
        SafetyAndSecurity{

        }
    }

    Component{
        id:service
        Service{

        }
    }

    Component{
        id:mapSettings
        MapThemes{

        }
    }


    function switchPage(index){
        switch(index){
        case 0:
            mainStack.replace(null,quickControl)
            break;
        case 1:
            mainStack.replace(null,light)
            break;
        case 2:
            mainStack.replace(null,lock)
            break;
        case 3:
            mainStack.replace(null,display)
            break;
        case 4:
            mainStack.replace(null,driving)
            break;
        case 5:
            mainStack.replace(null,autopilote)
            break;
        case 6:
            mainStack.replace(null,safety)
            break;
        case 7:
            mainStack.replace(null,service)
            break;
        case 8:
            mainStack.replace(null,mapSettings)
            break;
        }
    }

    SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Horizontal

        handle: Item {
            visible: false
        }

        Rectangle {
            id: mainRect
            color: Theme.isDarkMode ? "#161616" : "#FFFFFF"
            SplitView.preferredWidth: 400
            SplitView.maximumWidth: 400
            SplitView.minimumWidth: 400

            ListView{
                id:listItemView
                anchors.fill: parent
                anchors.margins: 10
                focus: true
                spacing: 25 // Add spacing here between items
                highlightFollowsCurrentItem :true
                onCurrentIndexChanged: {
                    root.switchPage(currentIndex)
                }

                highlight: Item{
                    visible: false
                }

                model: SideListModel{}
                delegate: SideListDelegate{
                    width: listItemView.width
                    lightIconRectIcon:iconName
                    darkIconRectIcon:iconName.replace(Qt.resolvedUrl("qrc:/Icons/Settings/"), Qt.resolvedUrl("qrc:/Icons/Settings/light/"));
                    iconRectColor: iconColor
                    spacing: 50
                    onClicked:{
                        ListView.view.currentIndex = index
                        root.switchPage(index)
                    }
                }
            }
        }

        Rectangle {
            id: collapsibleRect
            SplitView.fillWidth: true
            color: Theme.isDarkMode ? "#0E0E0E" : "#F0F0F0"
            clip: true
            Loader{
                id:mainLoader
                anchors.fill: parent
                StackView{
                    id:mainStack
                    anchors.fill: parent
                    initialItem:QuickControl{}
                }
            }
        }
    }
}
