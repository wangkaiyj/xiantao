pragma Singleton
import QtQml 2.13
import QtQuick 2.13

QtObject {

    property int titlebar_height: 42

    property font header_font: Qt.font({
                                           "family": "Microsoft Yahei",
                                           "pixelSize": 16,
                                           "weight": 57
                                       })
    property font text_font: Qt.font({
                                         "family": "Microsoft Yahei",
                                         "pixelSize": 12
                                     })
    property color text_light_color: "#A7AEB1"
    property color text_dark_color: "#324148"

    property color background_title_color: "#FFFFFF"
    property color background_frame_color: "#F5F5F6"

    property color button_nor_color: "#10ACEC"
    property color button_hov_color: "#0EA0DC"
    property color button_text_color: "#FFFFFF"

    property color border_nor_color: "#ECECED"
    property color border_hov_color: "#10ACEC"

    property color table_background_color: "#FFFFFF"
    property color table_head_background_color: "#10ACEC"
    property color table_head_text_color: "#FFFFFF"
    property color table_row_hov_color: "#F5F5F6"

    property color scroll_handle_nor_color: "#C1C1C1"
    property color scroll_handle_hov_color: "#A8A8A8"

    property Component scroll_handle: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        color: styleData.pressed || styleData.hovered ? scroll_handle_hov_color : scroll_handle_nor_color
        opacity: styleData.pressed || styleData.hovered ? 1.0 : 0.6
    }

    property Component scroll_background: Item {
        implicitWidth: 18
        implicitHeight: 18
    }

    property Component scroll_decrement: Item {
        implicitWidth: 0
        implicitHeight: 0
    }

    property Component scroll_increment: Item {
        implicitWidth: 0
        implicitHeight: 0
    }

    property Component scroll_corner: Item {
        implicitWidth: 0
        implicitHeight: 0
    }
}
