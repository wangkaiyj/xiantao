import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

Page {
    id: root

    signal logined(var mode)

    background: Item {

    }

    Item {
        anchors.fill: parent

        Button {
            id: button01
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            width: 120
            height: 60
            font: Theme.header_font
            text: "人员统计"
            anchors.rightMargin: 20
            background: Rectangle {
                color: button01.hovered ? Theme.button_hov_color : Theme.button_nor_color
            }
            contentItem: Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: button01.font
                text: button01.text
                color: Theme.button_text_color
            }

            onClicked: {
                root.logined(0);
            }
        }

        Button {
            id: button02
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            width: 120
            height: 60
            font: Theme.header_font
            text: "人员管理"
            anchors.leftMargin: 20
            background: Rectangle {
                color: button02.hovered ? Theme.button_hov_color : Theme.button_nor_color
            }
            contentItem: Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: button02.font
                text: button02.text
                color: Theme.button_text_color
            }

            onClicked: {
                root.logined(1);
            }
        }
    }
}
