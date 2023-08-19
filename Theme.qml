pragma Singleton // We indicate that this QML Type is a singleton
import QtQuick 2.15

QtObject {
    readonly property bool isDarkMode: cSettings.isDark
    readonly property color footerBackground:"#0E0E0E" // isDarkMode ? "#0E0E0E" : "#FFFFFF"
    readonly property color background: isDarkMode ? "#0E0E0E" : "#F1F1F1"
    readonly property color fontColor: isDarkMode ? "#FFFFFF" : "#0E0E0E"

    /*Dashboard Propertes*/

    readonly property color backgroundColor:"#17161c"
    readonly property color footerColor:"#201f25"
    readonly property color forgroundColor:"#201f25"
    readonly property color buttonColor:"#2f2f39"
    readonly property color labledBackColor:"#2c2c34"
    readonly property color checkedIconColor:"#489eeb"
    readonly property color unCheckedIconColor :"#777781"
    readonly property color progressColor:"#2f2f39"
    readonly property color tileColor :"#439df3"
}
