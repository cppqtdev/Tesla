import QtQuick 2.0
import QtQuick.Controls 2.5

Label {
    property real size
    property string icon

    font.family: mainQmlApp.fontAwesomeFontLoader.name
    font.pixelSize: size
    text: icon
}
