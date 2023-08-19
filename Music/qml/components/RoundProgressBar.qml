import QtQuick 2.0
import CustomControls 1.0
import QtQuick.Layouts 1.3

RadialBar {
    height: width
    penStyle: Qt.RoundCap
    dialType: RadialBar.MinToMax
    startAngle: 180
    spanAngle: 70
    minValue: 0
    maxValue: 100
    value: 50
    textFont {
        family: "Halvetica"
        italic: false
        pointSize: 16
    }
    suffixText: ""
    textColor: "#FFFFFF"
}
