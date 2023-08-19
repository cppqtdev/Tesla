import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GeneralMagic 2.0
import "./Component"
import "./whether/components"
import "./Music/qml/components"
import "./Music/qml/views"
import "./Music/qml/delegates"
import Theme 1.0
import WeatherInfo 1.0

ApplicationWindow {
    id:root
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Tesla Self Driving")
    color: "#17161c"
//    flags: Qt.FramelessWindowHint
//    visibility: "FullScreen"
    signal applyTheme(var mapInfo)

    property string foreColor: Theme.fontColor
    property alias fontAwesomeFontLoader: fontAwesomeFontLoader

    onApplyTheme: {
        if(mapInfo){
            mapView.styleId = mapInfo.id;
            mapView.stylePath = mapInfo.filePath;
            mapView.zoomOut();
            mapView.zoomIn();
        }
    }

    FontLoader
    {
        id: fontAwesomeFontLoader
        source: "qrc:/Music/assets/fonts/fontawesome.otf"
    }


    /**********************************Music ***************/

    property alias mainQmlApp: root
    property string darkThemeColor: Theme.background
    //property alias stackLayout: stackLayout
    property alias menuDelegatePopup: menuDelegatePopup
    property alias menuPopup: menuPopup

    property bool isMusicPlaying: false
    property bool isMusicPaused: false
    property bool isShuffleEnabled: false
    property int repeatIndex: 0
    property int currentMusicIndex: 0
    property int clickedIndex: -1

    property int playerPosition: 0
    property int playerDuration: 0

    property real yCoordinate: 0

    property string musicTitle_ : ""
    property string artistName: "Unknown Artist"

    property ListModel musicModel: ListModel {}

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

//    RotationAnimator {
//        loops: Animation.Infinite
//        target: rotatingIcon;
//        from: 0;
//        to: 360;
//        duration: 3000
//        running: mainQmlApp.isMusicPlaying
//    }
    RotationAnimator {
        loops: Animation.Infinite
        target: rotatingIconSmall;
        from: 0;
        to: 360;
        duration: 3000
        running: mainQmlApp.isMusicPlaying
    }


    function updateTitles()
    {
        if(musicModel.count>0)
        {
            try{

                musicTitle_ = musicModel.get(currentMusicIndex)._title

            } catch (err)
            {

            }
        }
    }

    function getArtist()
    {
        if(musicModel.count>0)
        {
            musicTitle_ = musicModel.get(currentMusicIndex)._title

            var artist = musicTitle_.split("-")[0]

            artistName = artist===""? "Unknown Artist":artist.length>40? artist.slice(0,39)+" ...":artist

        }
    }

    onMusicTitle_Changed: getArtist()

    onIsMusicPlayingChanged: {
        if(mainQmlApp.isMusicPlaying)
            QmlInterface.startPlaying()

        else
            QmlInterface.pausePlaying()
    }

    onIsMusicPausedChanged: {
        if(mainQmlApp.isMusicPaused)
            QmlInterface.pausePlaying()

        else
            QmlInterface.startPlaying()
    }

    onIsShuffleEnabledChanged: {
        QmlInterface.setShuffle(isShuffleEnabled);
    }

    onRepeatIndexChanged: {
        QmlInterface.setPlaybackMode(repeatIndex);
    }

    onCurrentMusicIndexChanged: {
        QmlInterface.setCurrentIndex(currentMusicIndex)

        updateTitles()
    }

    Connections
    {
        target: QmlInterface

        function onMusicIndexChanged() {
            // Changed from Qt player

            if(mainQmlApp.currentMusicIndex !== QmlInterface.getCurrentMusicIndex())
                mainQmlApp.currentMusicIndex = QmlInterface.getCurrentMusicIndex()
        }

        function onMusicListSizeChanged() {
            // Update music list

            musicModel.clear()

            for(var i=0; i<data.length; i++)
                musicModel.append({"_no":i+1, "_title":data[i], "_length":"03.20"})

            updateTitles()
        }

        function onPlayerPositionChanged(data) {
            // console.log("Position: ", data)
            playerPosition = data;
        }

        function onMusicDurationChanged(data) {
            // console.log("Length: ", data)
            playerDuration = data;
        }
    }

    MenuPopup
    {
        id: menuPopup
        x: root.width - 50 - width
        y: 5
    }

    MusicDelegateMenuPopup
    {
        id: menuDelegatePopup

        x: root.width - 50 - width
        y: yCoordinate

        onClosed: clickedIndex = -1
    }
    /**********************************End Music************/


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
            win.y = rightArea.height + musicPane.height - win.height + 10;
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
            win.y = rightArea.height + musicPane.height - win.height + 10;
            win.onHeightChanged.connect(function() {
                win.x = leftArea.width + 20;
                win.y = rightArea.height - win.height + 10;
            });
            win.show();
        }
    }

    header: Rectangle{
        color: "transparent"
        width: parent.width
        height: 60
        IconButton{
            anchors.centerIn: parent
            roundIcon: true
            iconHeight: 28
            iconWidth: 28
            setIcon: Theme.isDarkMode ? "qrc:/Icons/Tesla Logo.svg" : "qrc:/Icons/black/Tesla Logo.svg"
            onClicked: {
                cSettings.isDark = !cSettings.isDark
            }
        }
        RowLayout {
            anchors.leftMargin: 20
            anchors.rightMargin: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            ColumnLayout{
                spacing: 2
                Label{
                    id: currentTime
                    Layout.alignment: Qt.AlignLeft
                    text: Qt.formatDateTime(new Date(), "hh:mm a")
                    font.pixelSize: 22
                    font.family: root.fontAwesomeFontLoader.name
                    font.bold: Font.Normal
                    color: Theme.fontColor
                    Timer {
                        interval: 500
                        running: true
                        repeat: true
                        onTriggered:{
                            currentTime.text = Qt.formatDateTime(new Date(), "hh:mm a")
                        }
                    }
                }

                Label{
                    id: currentDate
                    Layout.alignment: Qt.AlignLeft
                    text: Qt.formatDateTime(new Date(), "dddd | MMM dd , yyyy")
                    font.pixelSize: 14
                    font.family: root.fontAwesomeFontLoader.name
                    font.bold: Font.Normal
                    color: Theme.fontColor
                    Timer {
                        interval: 500
                        running: true
                        repeat: true
                        onTriggered:{
                            currentDate.text = Qt.formatDateTime(new Date(), "dddd | MMM dd , yyyy")
                        }
                    }
                }
            }

            Item{
                Layout.fillWidth: true
            }

            RowLayout{
                spacing: 2
                IconButton{
                    implicitHeight: 45
                    implicitWidth: 45
                    roundIcon: true
                    iconHeight: 42
                    iconWidth: 42
                    setIcon: Theme.isDarkMode ? "qrc:/Icons/bluetooth.svg" : "qrc:/Icons/black/bluetooth.svg"
                }

                IconButton{
                    setIconSize: 22
                    implicitHeight: 42
                    implicitWidth: 42
                    iconBackground: "transparent"
                    setIconColor : Theme.fontColor
                    setIconText: "\uf3c5"
                }

                IconButton{
                    implicitHeight: 45
                    implicitWidth: 45
                    roundIcon: true
                    iconHeight: 42
                    iconWidth: 42
                    setIcon: Theme.isDarkMode ? "qrc:/Icons/cell signal.svg" : "qrc:/Icons/black/cell signal.svg"
                }
            }
            IconButton{
                roundIcon: true
                implicitHeight: 55
                implicitWidth: 55
                iconHeight: 42
                iconWidth: 42
                radius:16
                setIcon: "qrc:/Icons/Adesh.jpg"
                enabled: false
            }

            Label{
                text: qsTr("Aksh Singh")
                font.pixelSize: 16
                font.family: "Montserrat"
                font.bold: Font.Normal
                color: Theme.fontColor
            }
        }
    }

    footer: Rectangle{
        color: "#201f25"
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
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                checked: true
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf1b9"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }
            IconButton{
                implicitHeight: 75
                implicitWidth: 75
                iconHeight: 42
                iconWidth: 42
                roundIcon:true
                checkable: true
                iconBackground: checked ? "#26374b": Theme.buttonColor
                setIcon: "qrc:/Icons/defrost.svg"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }
            IconButton{
                implicitHeight: 75
                implicitWidth: 75
                iconHeight: 42
                iconWidth: 42
                roundIcon:true
                checkable: true
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIcon: "qrc:/Icons/heater.svg"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }

            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf3c5"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }

            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                checked: navigation.active
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf601"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }
            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                checked: mainQmlApp.isMusicPlaying
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf001"
                onCheckedChanged: {
                    if(checked){

                    }
                }
                onClicked: createMusicDialog()
            }
            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf1de"
                onClicked: createSettingsDialog()
            }
            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf3ce"
                onCheckedChanged: {
                    if(checked){

                    }
                }
            }
            IconButton{
                setIconSize:32
                implicitHeight: 75
                implicitWidth: 75
                checkable: true
                checked: mainQmlApp.isMusicPlaying
                iconBackground: checked ?
                                    "#26374b": Theme.buttonColor
                setIconColor :checked ? Theme.checkedIconColor : "#777781"
                setIconText: "\uf028"
                onCheckedChanged: {
                    if(checked){

                    }
                }
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
        spacing: 20
        Page{
            id:leftArea
            clip: true
            Layout.fillHeight: true
            Layout.margins: 10
            Layout.rightMargin: 5
            Layout.preferredWidth: 580
            background: Rectangle{
                anchors.fill: parent
                color: "#363640"
                radius: 20
            }

            Image{
                id:carModel
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/Icons/car.png"
            }
            Label {
                id:carLabel
                text: qsTr("Tesla Model 3")
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 18
                color: "white"
                font.bold: Font.DemiBold
                font.weight: Font.Normal
                font.family: root.fontAwesomeFontLoader.name
                anchors{
                    horizontalCenter: carModel.horizontalCenter
                    top: carModel.bottom
                    topMargin: 5
                }
            }

            TSlider{
                id:travelSlider
                height: 20
                labelVisible:false
                setHandleHeight:20
                checkedColor: "#2bbe6d"
                stepSize: 1
                from:0
                to: navigation.active ? navigation.currentInstruction.traveledDistance+ navigation.currentInstruction.remainingTravelDistance : 100
                value: navigation.active ? navigation.currentInstruction.traveledDistance : 0
                width: parent.width * 0.8
                anchors{
                    horizontalCenter: carModel.horizontalCenter
                    top: carLabel.bottom
                    topMargin: 60
                }
            }

            RowLayout{
                id:travelInfo
                width:travelSlider.width
                spacing: 10
                anchors{
                    horizontalCenter: carModel.horizontalCenter
                    top: travelSlider.bottom
                    topMargin: 15
                }
                IconButton{
                    implicitHeight: 45
                    implicitWidth: 45
                    radius:16
                    setIconColor :"#68acd9"
                    setIconText: "\uf52f"
                }
                ColumnLayout{
                    Label {
                        text: distance(navigation.currentInstruction.remainingTravelDistance )
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 18
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                    Label {
                        text: qsTr("Remaining")
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 10
                        color: "white"
                    }
                }
                ColumnLayout{
                    Label {
                        text: qsTr("128 wh/km")
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 18
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                    Label {
                        text: qsTr("Average")
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 10
                        color: "white"
                    }
                }
                ColumnLayout{
                    Label {
                        text: qsTr("35.5 kWm")
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 18
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                    Label {
                        text: qsTr("Full Capacity")
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 10
                        color: "white"
                    }
                }

            }

            Rectangle{
                clip: true
                anchors{
                    left: parent.left
                    leftMargin: -20
                    top: travelInfo.bottom
                    topMargin: 70
                }
                width: parent.width * 0.45
                height: 230
                color: "#2c2c34"
                border.width: 1
                border.color: "#68acd9"
                radius: 20

                ColumnLayout{
                    height: parent.height * 0.7
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 40

                    Label {
                        text: qsTr("Speed")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 18
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }

                    Label {
                        text: qsTr("128")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 65
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                    Label {
                        text: qsTr("km/h")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 18
                        color: "grey"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                }
            }

            Item{
                anchors{
                    right: parent.right
                    rightMargin: 5
                    top: travelInfo.bottom
                    topMargin: 70
                }
                width: parent.width * 0.55
                height: 230
                ColumnLayout{
                    height: parent.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    Label {
                        text: qsTr("Status")
                        Layout.alignment: Qt.AlignLeft
                        font.pixelSize: 18
                        color: "white"
                        font.family: "Montserrat"
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                    }
                    RowLayout{
                        spacing: 15
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\ue0c7"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\uf622"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\uf5df"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\uf8fa"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                    }
                    RowLayout{
                        spacing: 15
                        width: parent.width
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\uf63a"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\ue612"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                        IconButton{
                            implicitHeight: 55
                            implicitWidth: 55
                            radius:16
                            checkable: true
                            setIconColor :checked ? Theme.checkedIconColor : "#777781"
                            setIconText: "\uf134"
                            iconBackground: checked ? "#26374b": Theme.buttonColor
                        }
                    }

                }
            }
            LabelSelector{
                radius:16
                setColors: "#439df3"
                anchors{
                    horizontalCenter: carModel.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 20
                }
                lableList: ["N","D","P","R"]
            }
        }
        ColumnLayout{
            spacing: 20
            Layout.fillWidth: true
            Layout.margins: 10
            Layout.leftMargin: 5
            Pane{
                id:rightArea
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.70
                padding: 0
                clip: true
                background: Rectangle{
                    anchors.fill: parent
                    color: "#17161c"
                    radius: 20
                    clip: true
                }

                ColumnLayout{
                    z:2
                    spacing: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle{
                        id:zoomInOut
                        implicitHeight: 130
                        implicitWidth: 55
                        radius: 16
                        color: Theme.buttonColor
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
                                implicitWidth: 55
                                implicitHeight: 55
                                setIcon: Theme.isDarkMode ? "qrc:/Icons/unknown/dark/plus.svg" : "qrc:/Icons/unknown/light/plus.svg"
                                onClicked: mapView.zoomIn()
                            }

                            IconButton{
                                implicitWidth: 55
                                implicitHeight: 55
                                setIcon:Theme.isDarkMode ? "qrc:/Icons/unknown/dark/minus.svg" : "qrc:/Icons/unknown/light/minus.svg"
                                onClicked: mapView.zoomOut()
                            }
                        }
                    }

                    IconButton{
                        visible: !navigation.active
                        implicitHeight: 55
                        implicitWidth: 55
                        radius:16
                        checkable: true
                        setIconColor :checked ? Theme.checkedIconColor : "#777781"
                        setIconText: "\uf14e"
                        iconBackground: checked ? "#26374b": Theme.buttonColor
                    }
                    IconButton{
                        visible: ServicesManager.settings.connected && !navigation.active
                        implicitHeight: 55
                        implicitWidth: 55
                        radius:16
                        setIconSize:18
                        checkable: true
                        setIconColor :checked ? Theme.checkedIconColor : "#777781"
                        setIconText: "\uf124"
                        iconBackground: checked ? "#26374b": Theme.buttonColor
                        onClicked: routingService.update()
                    }
                    IconButton{
                        visible: mapView.routeCollection.mainRoute.valid
                        implicitHeight: 55
                        implicitWidth: 55
                        radius:16
                        checkable: true
                        setIconColor :checked ? Theme.checkedIconColor : "#777781"
                        setIconText: "\uf601"
                        iconBackground: checked ? "#26374b": Theme.buttonColor
                        onClicked: navigation.active = !navigation.active
                    }
                }
                Rectangle{
                    z:2
                    width: parent.width + 30
                    height: parent.height + 30
                    anchors.centerIn: parent
                    color: "transparent"
                    border.width: 20
                    border.color: "#17161c"
                    radius: 40
                }

                MapView {
                    id: mapView
                    z:1
                    clip: true
                    width: parent.width - 5
                    height: parent.height - 5
                    anchors.centerIn: parent
                    viewAngle: 25
                    cursorVisibility: false
                    buildingsVisibility: MapView.BuildingsVisibility.Hide
                    detailsQualityLevel: MapView.DetailsQualityLevel.High

                    onRouteSelected: {
                        routeCollection.mainRoute = route;
                        centerOnRoute(route);
                        console.log("Route selected, centering:" + route.summary);
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
                        color: "#363640"

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
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
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
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
                                }
                            }
                            RowLayout{
                                spacing: 50
                                Label {
                                    text: distance(navigation.currentInstruction.traveledDistance)
                                    Layout.alignment: Qt.AlignLeft
                                    font.pixelSize: 18
                                    color: "white"
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
                                }
                                Item{
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: qsTr("Estimated Arrival")
                                    Layout.alignment: Qt.AlignRight
                                    color: "white"
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
                                    font.pixelSize: 18
                                }
                            }
                            RowLayout{
                                spacing: 50
                                Label {
                                    Layout.alignment: Qt.AlignLeft
                                    font.pixelSize: 18
                                    color: "white"
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
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
                                    font.family: "Montserrat"
                                    font.bold: Font.Normal
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

                    IconButton{
                        z:5
                        id:searchIcon
                        implicitHeight: 55
                        implicitWidth: 55
                        radius:16
                        checkable: true
                        setIconColor :checked ? Theme.checkedIconColor : "#777781"
                        setIconText: "\uf130"
                        iconBackground: checked ? "#26374b": Theme.buttonColor

                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        onClicked: {
                            //                            searchIcon.visible = false
                            //                            locationBox.visible = !locationBox.visible
                        }
                    }

                    ColumnLayout{
                        id:locationBox
                        spacing: 10
                        z:5
                        visible: from.text
                        anchors.top: parent.top
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

            RowLayout{
                spacing: 20
                Page{
                    id:musicPane
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width /2

                    IconButton{
                        roundIcon: true
                        implicitHeight: 55
                        implicitWidth: 55
                        iconHeight: 48
                        iconWidth: 48
                        radius:16
                        setIcon: "qrc:/Icons/spotify_circle.svg"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.topMargin: 15
                    }

                    background: Rectangle{
                        anchors.fill: parent
                        color: "#363640"
                        radius: 20
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
                    }

                    ColumnLayout{
                        anchors.fill: parent
                        anchors.margins: 10
                        RowLayout{
                            Layout.leftMargin: 20
                            Layout.alignment: Qt.AlignLeft
                            spacing: 30

                            IconButton{
                                Layout.alignment: Qt.AlignVCenter
                                roundIcon: true
                                implicitHeight: 100
                                implicitWidth: 100
                                iconHeight: 100
                                iconWidth: 100
                                radius:16
                                setIcon: "qrc:/Icons/spotify.svg"
                            }

                            ColumnLayout{
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
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
                                RowLayout{
                                    Layout.fillWidth: true
                                    spacing: 25

                                    Slider{
                                        from:0
                                        to: 100
                                        value: playerDuration === 0? 0:(playerPosition * 100)/playerDuration
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    AppIcon{
                                        id: rotatingIconSmall;
                                        icon: "\uf51f";
                                        color: "#516b8e"
                                        size: 32
                                    }
                                }

                            }
                        }
                        RowLayout
                        {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 75
                            IconButton{
                                implicitHeight: 55
                                implicitWidth: 55
                                radius:16
                                checked:mainQmlApp.isShuffleEnabled
                                checkable: true
                                setIconColor :checked ? Theme.checkedIconColor : foreColor
                                setIconText: "\uf074"
                                onCheckedChanged: {
                                    mainQmlApp.isShuffleEnabled = checked
                                }
                            }
                            IconButton{
                                implicitHeight: 55
                                implicitWidth: 55
                                radius:16
                                setIconColor : mainQmlApp.foreColor
                                setIconText: "\uf04a"
                                onClicked: QmlInterface.playPrevious()
                            }

                            IconButton{
                                implicitHeight: 60
                                implicitWidth: 60
                                radius: 30
                                iconBackground: mainQmlApp.isMusicPlaying ? "#2bbe6d" : "transparent"
                                setIconColor : mainQmlApp.foreColor
                                setIconText: mainQmlApp.isMusicPlaying? "\uf04c":"\uf04b"
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

                            IconButton{
                                implicitHeight: 55
                                implicitWidth: 55
                                radius:16
                                setIconColor : mainQmlApp.foreColor
                                setIconText: "\uf04e"
                                onClicked: QmlInterface.playNext()
                            }

                            IconButton{
                                implicitHeight: 55
                                implicitWidth: 55
                                radius:16
                                setIconColor : mainQmlApp.repeatIndex === 0? foreColor: Theme.checkedIconColor
                                setIconText: mainQmlApp.repeatIndex === 1? "\uf366":"\uf364"
                                onClicked: {
                                    mainQmlApp.repeatIndex += 1
                                    if(mainQmlApp.repeatIndex === 3)
                                        mainQmlApp.repeatIndex = 0
                                }
                            }
                        }
                    }
                }
                Page{
                    id: weatherWindow
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    background: Rectangle{
                        anchors.fill: parent
                        color: "#73b2df"
                        radius: 20
                    }
                    state: "loading"
                    states: [
                        State {
                            name: "loading"
                            PropertyChanges { target: mainWeatherInfo; opacity: 0 }
                            PropertyChanges { target: wait; opacity: 1 }
                        },
                        State {
                            name: "ready"
                            PropertyChanges { target: mainWeatherInfo; opacity: 1 }
                            PropertyChanges { target: wait; opacity: 0 }
                        }
                    ]
                    AppModel {
                        id: model
                        onReadyChanged: {
                            if (model.ready)
                                weatherWindow.state = "ready"
                            else
                                weatherWindow.state = "loading"
                        }
                    }
                    Item {
                        id: wait
                        anchors.fill: parent

                        Text {
                            text: "Loading weather data..."
                            anchors.centerIn: parent
                            font.pointSize: 18
                        }
                    }
                    BigForecastIcon {
                        id: mainWeatherInfo
                        anchors.fill: parent
                        radius: 20
                        weatherIcon: (model.hasValidWeather
                                      ? model.weather.weatherIcon
                                      : "01d")
                        topText: (model.hasValidWeather
                                  ? model.weather.temperature
                                  : "??")
                        minText: (model.hasValidWeather
                                  ? model.weather.minTemperature
                                  : "??")
                        bottomText: (model.hasValidWeather
                                     ? model.weather.weatherDescription
                                     : "No weather data")
                        dateText: (model.hasValidWeather ?
                                       model.weather.dayOfWeek : "??")

                        MouseArea {
                            height: 120
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 49
                            anchors.leftMargin: 0
                            anchors.topMargin: -49
                            anchors.fill: parent
                            onClicked: {
                                model.refreshWeather()
                            }
                        }
                    }

                }
            }
        }
    }
}
