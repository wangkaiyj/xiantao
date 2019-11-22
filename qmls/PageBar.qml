import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item {
    id: root

    property int totalCount: 0
    property int pageCount: 50
    property int curPage: 0
    onTotalCountChanged: curPage = 0

    function back() {
        --curPage;
    }

    function front() {
        ++curPage;
    }

    RowLayout {
        height: parent.height
        anchors.right: parent.right
        layoutDirection: Qt.RightToLeft
        spacing: 10

        Text {
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            font: Theme.text_font
            color: Theme.text_dark_color
            text: "总人数："+Function.thousandSeparator(root.totalCount)
        }

        Button {
            id: leftButton
            Layout.alignment: Qt.AlignVCenter
            enabled: ((root.curPage+1)*root.pageCount>=root.totalCount) ? false : true
            background: Item {

            }
            contentItem: Item {
                width: 32
                Arrow {
                    anchors.centerIn: parent
                    width: 9
                    height: 18
                    direction: Arrow.Right
                    themeColor: leftButton.enabled ? Theme.text_dark_color : Theme.text_light_color
                }
            }
            onClicked: root.front()
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            font: Theme.text_font
            color: Theme.text_dark_color
            text: Function.thousandSeparator(root.curPage+1)
        }

        Button {
            id: rightButton
            Layout.alignment: Qt.AlignVCenter
            enabled: root.curPage <= 0 ? false : true
            background: Item {

            }
            contentItem: Item {
                height: 32
                width: 32
                Arrow {
                    anchors.centerIn: parent
                    width: 8
                    height: 16
                    direction: Arrow.Left
                    themeColor: rightButton.enabled ? Theme.text_dark_color : Theme.text_light_color
                }
            }
            onClicked: root.back()
        }
    }
}
