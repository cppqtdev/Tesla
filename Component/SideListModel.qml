import QtQuick 2.15
import QtQuick.Controls 2.5
//
// get All the unicode icon : https://emojiterra.com/satellite/
// https://iconduck.com/ --> duotone icons
// https://www.svgrepo.com/collection/iconsax-duotone-filled-icons/ --> best icons
//https://stackoverflow.com/questions/30266881/what-is-the-right-way-to-use-qquickimageprovider
ListModel {
    ListElement {
        iconName:"qrc:/Icons/Settings/quick controls.svg"
        iconColor:"transparent"
        name: "Quick Controls"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/lights.svg"
        iconColor:"transparent"
        name: "Lights"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/lock.svg"
        iconColor:"transparent"
        name: "Locks"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/display.svg"
        iconColor:"transparent"
        name: "Display"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/model3-icon-small.svg"
        iconColor:"transparent"
        name: "Driving"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/steering wheel-small.svg"
        iconColor:"transparent"
        name: "Autopilot"
    }
    ListElement {
        iconName:"qrc:/Icons/Settings/safety and security.svg"
        iconColor:"transparent"
        name: "Safety & Security"
    }

    ListElement {
        iconName:"qrc:/Icons/Settings/service.svg"
        iconColor:"transparent"
        name: "Service"
    }

    ListElement {
        iconName: "qrc:/Icons/Settings/gear.svg"
        iconColor:"transparent"
        name: "Map Settings"
    }
}
