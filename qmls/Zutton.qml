import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Button {
    id: control
    property string normalImage
    property string hoveredImage
    font: Theme.text_font
    highlighted: true
    leftPadding: text ? 0 : 5
    rightPadding: text ? 0 : 5
    topPadding: 0
    bottomPadding: 0
    contentItem: RowLayout {
        id: rowLayout
        height: parent.height
        spacing: 5
        Image {
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Image.AlignVCenter
            source: control.down || control.hovered ? hoveredImage : normalImage
        }
        Text {
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            text: control.text
            font: control.font
            color: control.down || control.hovered ? Theme.text_dark_color : Theme.text_light_color
        }
    }

    background: Rectangle {
        color: "transparent"
    }
}
