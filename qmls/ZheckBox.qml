import QtQuick 2.12
import QtQuick.Controls 2.5

CheckBox {
    id: control
    tristate: true
    checkState: Qt.Unchecked
    spacing: 2
    font: Theme.text_font
    nextCheckState: function() {
        if (checkState === Qt.Checked) {
            return Qt.Unchecked;
        }
        else {
            return Qt.Checked;
        }
    }
    indicator: Item {
        implicitWidth: 16
        implicitHeight: 16
        anchors.verticalCenter: parent.verticalCenter
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: {
                if(control.checkState === Qt.PartiallyChecked) return "images/check_partial.png";
                if(control.checkState === Qt.Checked) return "images/check_yes.png";
                return  "images/check_no.png";
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
