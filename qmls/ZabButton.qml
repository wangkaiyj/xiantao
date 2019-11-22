import QtQuick 2.12
import QtQuick.Controls 2.5

TabButton {
    id: control
    font: Theme.text_font
    readonly property bool actived: TabBar.index === TabBar.tabBar.currentIndex
    topPadding: 0
    bottomPadding: 0

    contentItem: Text {
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        color: actived ? Theme.text_dark_color : Theme.text_light_color
    }

    background: Rectangle {

        color: "transparent"
    }
}
