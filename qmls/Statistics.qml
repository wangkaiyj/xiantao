import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

Page {
    id: root

    background: Item {

    }

    header: Item {
        height: 32
    }

    ZableView {
        anchors.fill: parent
        anchors.margins: 1
        sourceModel: appCore.statsModel
        onOperateRow: {

        }
    }
}
