import QtQuick 2.12
import QtQuick.Controls 2.5

TextField {
      id: control      
      placeholderText: "请输入关键字..."
      font: Theme.text_font
      color: Theme.text_dark_color
      rightInset: -32
      rightPadding: 0
      background: Rectangle {
          color: "transparent"
          border.width: 1
          border.color: control.activeFocus || control.hovered ? Theme.border_hov_color : Theme.border_nor_color

          Zutton {
              visible: control.text ? true : false
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              normalImage: "images/colse.png"
              hoveredImage: "images/close_hover.png"
              onClicked: control.text = ""
          }
      }
  }
