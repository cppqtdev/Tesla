import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GeneralMagic 2.0
import "./Component"
import Theme 1.0

/*

  UI design

  https://www.figma.com/proto/ZVtsja4HrrnTepCXy4UL1o/Tesla-Model-3-(Community)?type=design&node-id=193-11415&t=IRGHY8V169BrNXsq-0&scaling=scale-down&page-id=0%3A1
*/
ApplicationWindow {
    id:root
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Tesla Self Driving")
    signal applyTheme(var mapInfo)
//    flags: Qt.FramelessWindowHint
//    visibility: "FullScreen"
    onApplyTheme: {
        if(mapInfo){
            mapView.styleId = mapInfo.id;
            mapView.stylePath = mapInfo.filePath;
            mapView.zoomOut();
            mapView.zoomIn();
        }
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    function createSettingsDialog(){
        var component = Qt.createComponent("qrc:/Component/SettingsDialog.qml");
        var win = component.createObject(root);
        if (win !== null) {
            // Calculate the x-coordinate to center the win object
            win.x = leftArea.width + 20;

            // Calculate the y-coordinate for the bottom position
            win.y = rightArea.height - win.height + 10;
            win.applyTheme.connect(function(mapInfo) {
                       root.applyTheme(mapInfo);
                   });
            win.show();
        }
    }

    function createMusicDialog(){
        var component = Qt.createComponent("qrc:/Music/qml/Music.qml");
        var win = component.createObject(root);
        if (win !== null) {
            win.x = leftArea.width + 20;
            win.y = rightArea.height - win.height + 10;
            //win.musicModel.clear()
            win.onHeightChanged.connect(function() {
                win.x = leftArea.width + 20;
                win.y = rightArea.height - win.height + 10;
            });
            win.show();
        }
    }

    footer: Rectangle{
        color: Theme.footerBackground
        width: parent.width
        height: 120
        RowLayout{
            spacing: 110
            anchors.leftMargin: 110
            anchors.rightMargin: 110
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            IconButton{
                setIcon: "qrc:/Icons/model3-icon.svg"
                onClicked: createSettingsDialog()
            }
            IconButton{
                setIcon: "qrc:/Icons/defrost.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/heater.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/seat.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/Driver Temp.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/fan.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/Driver Temp.svg"
            }
            IconButton{
                isMirror:true
                setIcon: "qrc:/Icons/seat.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/music.svg"
                onClicked: createMusicDialog()
            }
            IconButton{
                setIcon: "qrc:/Icons/phone.svg"
            }
            IconButton{
                setIcon: "qrc:/Icons/volume.svg"
            }
        }
    }

    function distance(meters)
    {
        return meters >= 1000 ? (meters / 1000.).toFixed(3) + " Km" :  meters.toFixed(0) + " m";
    }

    property var updater: ServicesManager.contentUpdater(ContentItem.Type.RoadMap)
    Component.onCompleted: {
        root.showMaximized()
        ServicesManager.settings.token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI1MGY2MDIxMS1jMmY4LTQ5M2UtOWFlOC1jNmFmZGNmNzg2ZDkiLCJleHAiOjE2OTI1NjUyMDAsImlzcyI6IkdlbmVyYWwgTWFnaWMiLCJqdGkiOiIwMGRjZDg4Zi1hM2ZiLTQ1OWUtOWVlMS1lOGU1NzE2MWFiMTciLCJuYmYiOjE2OTIwMTg2MzR9.TOsO5Mdrac7i4uJgt0-mghIGBRzNCztfMy7UVEnQlKd_lYePFc_SDUFbA0we1VXDI32oAQugnnRGCU_zkYIyng";

        ServicesManager.logLevel = ServicesManager.Error;
        ServicesManager.settings.allowInternetConnection = true; // enable connection to online services

        updater.autoApplyWhenReady = true;
        updater.update();
    }


    RoutingService {
        id: routingService
        type: Route.Type.Fastest
        transportMode: Route.TransportMode.Car
        routeRangesQuality:100

        waypoints: LandmarkList {
            Landmark {
                name: "start"
                coordinates: Coordinates { //{"lat":28.4646,"lon":77.0299}
                    latitude: 28.4646
                    longitude: 77.0299
                }
            }
            Landmark {
                name: "stop"
                coordinates: Coordinates { //28.7041° N, 77.1025° E
                    latitude: 28.7041
                    longitude: 77.1025
                }
            }
        }
        onFinished: {
            mapView.routeCollection.set(routeList);
            mapView.centerOnRouteList(routeList);
        }
    }

    NavigationService {
        id: navigation
        route: mapView.routeCollection.mainRoute
        simulation: true // change it to false (default) to perform real turn by turn navigation
        onActiveChanged: {
            if (active) {
                mapView.startFollowingPosition();
                mapView.routeCollection.clear(true /*keepMainRoute*/);
            }
        }

        onWaypointReached: console.log("WaypointReached :" + waypoint.name);
        onDestinationReached: mapView.routeCollection.clear();
        onNavigationError: {
            mapView.routeCollection.clear();
        }
        onNavigationRouteUpdated: {
            mapView.routeCollection.add(route, true);
            mapView.routeCollection.clear(true);
        }
    }

    // Main Screen

    RowLayout{
        anchors.fill: parent
        spacing: 0
        Page{
            id:leftArea
            Layout.fillHeight: true
            Layout.preferredWidth: 580
            background: Rectangle{
                anchors.fill: parent
                color: Theme.background
            }
            header: Rectangle{
                width: parent.width
                height: 60
                color: "transparent"

                IconButton{
                    setIcon: "qrc:/Icons/tire pressure.svg"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }
                IconButton{
                    setIcon: "qrc:/Icons/headlights.svg"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                }
            }
            contentItem: Page{
                anchors.fill: parent
                padding: 0
                background: Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                }
                header: Rectangle{
                    width: parent.width
                    height: 149
                    color: "transparent"

                    RowLayout{
                        spacing: 27
                        anchors{
                            bottom: parent.bottom
                            bottomMargin: 10
                            left: parent.left
                            leftMargin: 20
                        }

                        Label{
                            text: "R"
                            opacity: 0.4
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Label{
                            text: "P"
                            opacity: 0.4
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Label{
                            text: "N"
                            opacity: 0.4
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Label{
                            text: "D"
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Label{
                        text: "160"
                        font.pixelSize: 45
                        font.family: "Montserrat"
                        font.bold: Font.Normal
                        color: Theme.fontColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: mphLabel.top
                        anchors.bottomMargin: 5
                    }

                    Label{
                        id:mphLabel
                        text: "MPH"
                        opacity: 0.4
                        font.pixelSize: 20
                        font.family: "Montserrat"
                        font.bold: Font.Normal
                        color: Theme.fontColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                    }

                    RowLayout{
                        spacing: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        Label{
                            text: "90 %"
                            opacity: 0.4
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Image{
                            Layout.alignment: Qt.AlignVCenter
                            source: "qrc:/Icons/battery.svg"
                        }

                    }

                    Rectangle{
                        color: "grey"
                        height: 2
                        width: parent.width - 20
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }
                }

                contentItem:Page {
                    padding: 0
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }
                    header: Rectangle{
                        width: parent.width
                        height: 80
                        color: "transparent"

                        IconButton{
                            setIcon: "qrc:/Icons/steering wheel.svg"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                        }

                        RowLayout{
                            spacing: 10
                            anchors.centerIn: parent
                            IconButton{
                                id:minus
                                setIcon:Theme.isDarkMode ? "qrc:/Icons/unknown/dark/minus.svg" : "qrc:/Icons/unknown/light/minus.svg"
                                Layout.alignment: Qt.AlignVCenter
                                onClicked: {
                                    var number = parseInt(cruise_Control.text)
                                    number = number - 1
                                    cruise_Control.text = number
                                }
                            }
                            Rectangle{
                                border.width: 4
                                border.color: "grey"
                                color: "transparent"
                                width: minus.width
                                height: minus.height
                                radius: height/2
                                Layout.alignment: Qt.AlignVCenter
                                Label{
                                    id:cruise_Control
                                    text: "30"
                                    opacity: 0.4
                                    font.pixelSize: 24
                                    font.family: "Montserrat"
                                    font.bold: Font.DemiBold
                                    color: Theme.fontColor
                                    anchors.centerIn: parent
                                }
                            }

                            IconButton{
                                id:plus
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/plus.svg" : "qrc:/Icons/unknown/light/plus.svg"
                                Layout.alignment: Qt.AlignVCenter
                                onClicked: {
                                    var number = parseInt(cruise_Control.text)
                                    number = number + 1
                                    cruise_Control.text = number
                                }
                            }
                        }

                        IconButton{
                            setIcon: "qrc:/Icons/Speed Limit.svg"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                        }
                    }
                    contentItem:SwipeView {
                        id: view
                        currentIndex: 1
                        anchors.fill: parent

                        Page {
                            id: firstPage
                            padding: 0
                            background: Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                            }
                            Image{
                                source: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/Group.png" : "qrc:/Icons/unknown/light/Group.png"
                                anchors.centerIn: parent
                            }
                        }

                        Page {
                            id: secondPage
                            padding: 0
                            background: Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                            }
                            Image{
                                source: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/Group.png" : "qrc:/Icons/unknown/light/Group.png"
                                anchors.centerIn: parent
                            }
                        }

                        Page {
                            id: thirdPage
                            padding: 0
                            background: Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                            }

                            TButton{
                                text: "open"
                                anchors.horizontalCenter: model3.horizontalCenter
                                anchors.bottom: model3.top
                            }

                            Image{
                                id:glow
                                smooth: true
                                visible: Theme.isDarkMode
                                source: "qrc:/Icons/Cars/headlights.png"
                                anchors.bottom: model3.top
                                anchors.horizontalCenter: model3.horizontalCenter
                                anchors.bottomMargin: - 60
                            }

                            Image{
                                id:model3
                                source: Theme.isDarkMode ? "qrc:/Icons/Cars/model 3_new.svg" : "qrc:/Icons/Cars/model 3-1_new.svg"
                                anchors.centerIn: parent
                            }

                            TButton{
                                text: "open"
                                anchors.horizontalCenter: model3.horizontalCenter
                                anchors.top: model3.bottom
                            }

                            TButton{
                                property bool isGlow: Theme.isDarkMode
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/scale.svg" : "qrc:/Icons/unknown/light/scale.svg"
                                anchors.verticalCenter: model3.verticalCenter
                                anchors.right: model3.left
                                anchors.leftMargin: 10
                                onClicked: {
                                    isGlow = !isGlow
                                    if(!isGlow){
                                        glow.visible = false
                                        model3.source = "qrc:/Icons/Cars/model 3-1_new.svg"
                                    }else{
                                        glow.visible =   Theme.isDarkMode
                                        model3.source =  Theme.isDarkMode ? "qrc:/Icons/Cars/model 3_new.svg" : "qrc:/Icons/Cars/model 3-1_new.svg"
                                    }
                                }
                            }
                        }
                    }

                    footer: Rectangle{
                        width: parent.width
                        height: 120
                        color: "transparent"

                        RowLayout{
                            anchors.centerIn: parent
                            spacing: 100
                            IconButton{
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/camera.svg" : "qrc:/Icons/dark/camera.svg"
                            }
                            IconButton{
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/power.svg" : "qrc:/Icons/dark/power.svg"
                            }

                            IconButton{
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                            }
                        }
                    }
                }

                footer:Item{
                    width: parent.width
                    height: 40
                    PageIndicator {
                        count: view.count
                        currentIndex: view.currentIndex
                        interactive: true
                        anchors.centerIn: parent
                    }
                }
            }
        }
        Item{
            id:rightArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout{
                z:2
                spacing: 20
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                Rectangle{
                    id:zoomInOut
                    implicitHeight: 160
                    implicitWidth: 75
                    radius: 20
                    color: Theme.isDarkMode ? "#1c1d21" : "#FFFFFF"
                    Rectangle{
                        z:2
                        width: zoomInOut.width - 15
                        color: "grey"
                        height: 1
                        anchors.centerIn: parent
                    }

                    ColumnLayout{
                        z:1
                        anchors.centerIn: parent
                        spacing: 20
                        IconButton{
                            implicitWidth: 60
                            implicitHeight: 60
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/plus.svg" : "qrc:/Icons/unknown/light/plus.svg"
                            onClicked: mapView.zoomIn()
                        }

                        IconButton{
                            implicitWidth: 60
                            implicitHeight: 60
                            setIcon:Theme.isDarkMode ? "qrc:/Icons/unknown/dark/minus.svg" : "qrc:/Icons/unknown/light/minus.svg"
                            onClicked: mapView.zoomOut()
                        }
                    }
                }

                Rectangle{
                    implicitHeight: 75
                    implicitWidth: 75
                    radius: 20
                    color: Theme.isDarkMode ? "#1c1d21" : "#FFFFFF"
                    IconButton{
                        iconWidth: 28
                        iconHeight: 28
                        roundIcon: true
                        anchors.centerIn: parent
                        setIcon: Theme.isDarkMode ? "qrc:/Icons/dark/gear.svg" : "qrc:/Icons/gear.svg"
                        onClicked: createSettingsDialog()
                    }
                }

                Rectangle{
                    visible: ServicesManager.settings.connected && !navigation.active
                    implicitHeight: 75
                    implicitWidth: 75
                    radius: 20
                    color: Theme.isDarkMode ? "#1c1d21" : "#FFFFFF"
                    IconButton{
                        rotation: -90
                        iconWidth: 42
                        iconHeight: 42
                        roundIcon: true
                        anchors.centerIn: parent
                        setIcon: Theme.isDarkMode ? "qrc:/Icons/navigation_light.svg" : "qrc:/Icons/navigation_dark.svg"
                        onClicked: {
                            routingService.update()
                        }
                    }
                }

                Rectangle{
                    visible: mapView.routeCollection.mainRoute.valid
                    implicitHeight: 75
                    implicitWidth: 75
                    radius: 20
                    color: Theme.isDarkMode ? "#1c1d21" : "#FFFFFF"
                    IconButton{
                        iconWidth: 24
                        iconHeight: 24
                        rotation: -90
                        anchors.centerIn: parent
                        setIcon: Theme.isDarkMode ? "qrc:/Icons/current_location_dark.svg" : "qrc:/Icons/current_location_light.svg"
                        onClicked: {
                           navigation.active = !navigation.active
                        }
                    }
                }
            }

            MapView {
                id: mapView
                z:1
                anchors.fill: parent
                viewAngle: 25
                cursorVisibility: false
                buildingsVisibility: MapView.BuildingsVisibility.Hide
                detailsQualityLevel: MapView.DetailsQualityLevel.High


                onRouteSelected: {
                    routeCollection.mainRoute = route;
                    centerOnRoute(route);
                    console.log("Route selected, centering:" + route.summary);
                }

                Rectangle {
                    id:topHeader
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 70
                    RowLayout {
                        anchors.leftMargin: 20
                        anchors.rightMargin: 40
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        IconButton{
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/lock.svg" : "qrc:/Icons/black/lock.svg"
                        }
                        IconButton{
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/bluetooth.svg" : "qrc:/Icons/black/bluetooth.svg"
                        }
                        IconButton{
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/cell signal.svg" : "qrc:/Icons/black/cell signal.svg"
                        }
                        Item{
                            Layout.preferredWidth: 55
                        }
                        IconButton{
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/alert.svg" : "qrc:/Icons/alert.svg"
                        }
                        IconButton{
                            setIcon: Theme.isDarkMode ? "qrc:/Icons/Tesla Logo.svg" : "qrc:/Icons/black/Tesla Logo.svg"
                            onClicked: {
                                cSettings.isDark = !cSettings.isDark
                            }
                        }
                        Item{
                            Layout.fillWidth: true
                        }

                        Label{
                            text: "17 ºC"
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                        }
                        Item{
                            Layout.preferredWidth: 14
                        }

                        Label{
                            id: currentTime
                            text: Qt.formatDateTime(new Date(), "hh:mm")
                            font.pixelSize: 20
                            font.family: "Montserrat"
                            font.bold: Font.Normal
                            color: Theme.fontColor
                            Timer {
                                interval: 500
                                running: true
                                repeat: true
                                onTriggered:{
                                    currentTime.text = Qt.formatDateTime(new Date(), "hh:mm")
                                }
                            }
                        }
                    }
                }


                Rectangle{
                    z:5
                    visible: navigation.active
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    implicitHeight: 140
                    implicitWidth: 420
                    radius: 20
                    color: "#439df3"

                    RowLayout{
                        width: parent.width
                        spacing: 0
                        anchors.centerIn: parent
                        Item{
                            Layout.alignment: Qt.AlignLeft
                            Layout.preferredWidth: parent.width * 0.33
                            Layout.fillHeight: true
                            RowLayout{
                                anchors.centerIn: parent
                                spacing: 20
                                DynamicIconView {
                                    width: 100
                                    height: 100
                                    arrowInner: "White"
                                    arrowOuter: "White"
                                    slotInner: "Grey"
                                    slotOuter: arrowOuter
                                    iconSource: navigation.currentInstruction.nextTurnDynamicIcon
                                }

                                Rectangle{
                                    width: 1
                                    height: 100
                                    color: "#5cb1ff"
                                }
                            }
                        }
                        ColumnLayout{
                            Layout.fillWidth: true
                            spacing: 5
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                font.pixelSize: 24
                                color: "white"
                                text: distance(navigation.currentInstruction.distanceToNextTurn)
                            }
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                color: "white"
                                Layout.fillWidth: true
                                font.pixelSize: 18
                                text: navigation.currentInstruction.nextStreetName
                            }
                        }
                    }
                }


                Rectangle{
                    z:5
                    visible: navigation.active
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    implicitHeight: 140
                    implicitWidth: 500
                    radius: 20
                    color: "#605f65"

                    ColumnLayout{
                        spacing: 5
                        anchors.margins: 5
                        anchors.centerIn: parent
                        Layout.fillWidth: true
                        RowLayout{
                            spacing: 50
                            Label {
                                text: navigation.currentInstruction.nextStreetName
                                Layout.alignment: Qt.AlignLeft
                                font.pixelSize: 24
                                color: "white"
                            }
                            Item{
                                Layout.fillWidth: true
                            }

                            Label {
                                text: {
                                    var currentTime = new Date();
                                    var timeToAdd = new Date();

                                    // Set the time interval to add (hours, minutes, seconds)
                                    timeToAdd.setHours(1);       // 1 hour
                                    timeToAdd.setMinutes(30);    // 30 minutes
                                    timeToAdd.setSeconds(15);    // 15 seconds

                                    // Add the time interval to the current time
                                    currentTime.setMilliseconds(currentTime.getMilliseconds() + timeToAdd.getTime());

                                    // Format the result to display as HH:mm:ss
                                    var hours = currentTime.getHours().toString().padStart(2, "0");
                                    var minutes = currentTime.getMinutes().toString().padStart(2, "0");
                                    var seconds = currentTime.getSeconds().toString().padStart(2, "0");

                                    return hours + ":" + minutes + ":" + seconds;
                                }
                                Layout.alignment: Qt.AlignRight
                                color: "white"
                                font.pixelSize: 18
                            }
                        }
                        RowLayout{
                            spacing: 50
                            Label {
                                text: distance(navigation.currentInstruction.traveledDistance)
                                Layout.alignment: Qt.AlignLeft
                                font.pixelSize: 18
                                color: "white"
                            }
                            Item{
                                Layout.fillWidth: true
                            }

                            Label {
                                text: qsTr("Estimated Arrival")
                                Layout.alignment: Qt.AlignRight
                                color: "white"
                                font.pixelSize: 18
                            }
                        }
                        RowLayout{
                            spacing: 50
                            Label {
                                Layout.alignment: Qt.AlignLeft
                                font.pixelSize: 18
                                color: "white"
                                text: distance(navigation.currentInstruction.remainingTravelDistance)
                            }

                            Slider{
                                from:0
                                to: navigation.currentInstruction.traveledDistance+ navigation.currentInstruction.remainingTravelDistance
                                value: navigation.currentInstruction.traveledDistance
                                Layout.alignment: Qt.AlignHCenter
                                Layout.fillWidth: true
                            }

                            Label {
                                Layout.alignment: Qt.AlignRight
                                color: "white"
                                font.pixelSize: 18
                                text: convertSecondsToTime(navigation.currentInstruction.remainingTravelTime) //navigation.currentInstruction.nextSpeedLimitVariation()
                                function convertSecondsToTime(seconds) {
                                    var hours = Math.floor(seconds / 3600);
                                    var remainingSeconds = seconds % 3600;
                                    var minutes = Math.floor(remainingSeconds / 60);
                                    var remainingMinutes = remainingSeconds % 60;

                                    var hoursStr = hours < 10 ? "0" + hours : hours;
                                    var minutesStr = minutes < 10 ? "0" + minutes : minutes;
                                    var secondsStr = remainingMinutes < 10 ? "0" + remainingMinutes : remainingMinutes;
                                    return hoursStr + ":" + minutesStr + ":" + secondsStr;
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    z:5
                    id:searchIcon
                    anchors.top: topHeader.bottom
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    implicitHeight: 75
                    implicitWidth: 75
                    radius: 20
                    color: Theme.isDarkMode ? "#1c1d21" : "#FFFFFF"
                    IconButton{
                        id:microSeach
                        property bool micro: true
                        iconWidth: 24
                        iconHeight: 24
                        anchors.centerIn: parent
                        setIcon: Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                        onClicked: {
                           searchIcon.visible = false
                           locationBox.visible = !locationBox.visible
                        }

                        Timer{
                            running: true
                            repeat: true
                            interval: 2000
                            onTriggered: {
                                microSeach.micro = !microSeach.micro
                                if(microSeach.micro){
                                    microSeach.setIcon = Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                                }else{
                                    microSeach.setIcon = Theme.isDarkMode ? "qrc:/Icons/search.svg" : "qrc:/Icons/search_dark.svg"
                                }
                            }
                        }
                    }
                }

                ColumnLayout{
                    id:locationBox
                    spacing: 10
                    z:5
                    visible: from.text
                    anchors.top: topHeader.bottom
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    SearchBox{
                        id:from
                        property bool micro: true
                        leftInset: -5
                        radius: implicitHeight / 2
                        leftPadding: 60
                        rightPadding: 10
                        setIcon : Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                        Timer{
                            running: true
                            repeat: true
                            interval: 2000
                            onTriggered: {
                                from.micro = !from.micro
                                if(from.micro){
                                    from.setIcon = Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                                }else{
                                    from.setIcon = Theme.isDarkMode ? "qrc:/Icons/search.svg" : "qrc:/Icons/search_dark.svg"
                                }
                            }
                        }
                        onEditingFinished: {
                            if(!text){
                                to.clear()
                                to.visible = false
                            }else{
                                to.visible = true
                                to.forceActiveFocus()
                            }
                        }
                        onTextChanged: {
                            if(!text){
                                from.visible  = false
                                searchIcon.visible = true
                                to.clear()
                                to.visible = false
                            }
                        }
                    }

                    SearchBox{
                        id:to
                        property bool micro: true
                        icon.mirror: true
                        setIcon : Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                        placeholderText: qsTr("To")
                        visible: false
                        leftInset: -5
                        radius: implicitHeight / 2
                        leftPadding: 64
                        rightPadding: 10
                        onEditingFinished: {

                        }
                        Timer{
                            running: true
                            repeat: true
                            interval: 2000
                            onTriggered: {
                                to.micro = !to.micro
                                if(to.micro){
                                    to.setIcon = Theme.isDarkMode ? "qrc:/Icons/microphone.svg" : "qrc:/Icons/dark/microphone.svg"
                                }else{
                                    to.setIcon = Theme.isDarkMode ? "qrc:/Icons/search.svg" : "qrc:/Icons/search_dark.svg"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
