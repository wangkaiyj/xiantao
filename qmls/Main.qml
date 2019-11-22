import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtShark.Window 1.0

ApplicationWindow {
    id: applicationWindow

    visible: true
    minimumWidth: 1024
    minimumHeight: 920
    flags: Qt.Window | Qt.FramelessWindowHint
    font: Theme.text_font
    color: Theme.background_frame_color

    FramelessHelper {
        id: framelessHelper

        titleBarHeight: Theme.titlebar_height
        Component.onCompleted: {
            addIncludeItem(titleBar)
            addExcludeItem(systemLayout)
        }
    }

    Rectangle {
        id: titleBar
        height: Theme.titlebar_height
        width: parent.width
        color: Theme.background_title_color
        Text {
            text: qsTr("仙桃统计局（试用版）")
            font: Theme.header_font
            color: Theme.text_dark_color
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            verticalAlignment: Text.AlignVCenter
        }
    }

    RowLayout {
        id: systemLayout
        anchors.verticalCenter: titleBar.verticalCenter
        anchors.right: titleBar.right
        anchors.rightMargin: 10
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillHeight: true
            spacing: 0
            currentIndex: 0
            visible: currentIndex <= 0 ? false : true
            width: currentIndex <= 0 ? 0 : implicitWidth
            background: Item {

            }

            TabButton {
                id: emptyTab
                width: 0
                height: 0
                contentItem: Item {
                    implicitWidth: 0
                    implicitHeight: 0
                }
                background: Item {
                    implicitHeight: 0
                    implicitWidth: 0
                }
            }

            ZabButton {
                text: "人员统计"
            }

            ZabButton {
                text: "人员管理"
            }
        }

        Zutton {
            Layout.alignment: Qt.AlignVCenter
            normalImage: "images/min.png"
            hoveredImage: "images/min_hover.png"
            onClicked: {
                framelessHelper.triggerMinimizeButtonAction();
            }
        }

        Zutton {
            Layout.alignment: Qt.AlignVCenter
            normalImage: Window.Maximized === applicationWindow.visibility ? "images/nmax.png" : "images/max.png"
            hoveredImage: Window.Maximized === applicationWindow.visibility ? "images/nmax_hover.png" : "images/max_hover.png"
            onClicked: {
                framelessHelper.triggerMaximizeButtonAction();
            }
        }

        Zutton {
            Layout.alignment: Qt.AlignVCenter
            normalImage: "images/colse.png"
            hoveredImage: "images/close_hover.png"
            onClicked: {
                framelessHelper.triggerCloseButtonAction();
            }
        }
    }

    SwipeView {
        width: parent.width
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        interactive: false
        currentIndex: tabBar.currentIndex

        Home {
            onLogined: {
                tabBar.currentIndex = mode+1;
            }
        }

        Statistics {

        }

        Manage {

        }
    }
}
