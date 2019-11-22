import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import org.app.models 1.0

QableView {
    id: tableView
    signal operateRow(var id, var role)
    property int startRow: 0
    property int endRow: -1
    property alias sourceModel: filterModel.source
    property alias filterValue: filterModel.filterValue
    property var checkedIds: []

    frameVisible: false
    backgroundVisible: false
    model: FilterTableModel {
        id: filterModel
        range: [startRow, endRow]
        onSourceModelChanged: {
            tableView.checkedIds = []
        }
        onFilterCountChanged: {
            tableView.checkedIds = []
        }
    }

    style: TableViewStyle {

        headerDelegate: Rectangle {
            implicitHeight: 32
            color: styleData.containsMouse?Theme.table_head_background_color : Theme.table_head_background_color
            property bool checkColumn: {
                var columnInfo = tableView.getColumn(styleData.column);
                if(columnInfo) return columnInfo.role === 'checkable' ? true : false;
                return false;
            }
            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                visible: !checkColumn
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: Theme.text_font
                text: styleData.value
                color: Theme.table_head_text_color
                wrapMode: Text.WordWrap
            }

            function headerClick() {
                var curState = checkBox.nextCheckState();
                if(curState) {
                    tableView.checkedIds = tableView.model.filterIds();
                }
                else {
                    tableView.checkedIds =[];
                }
            }

            ZheckBox {
                id: checkBox
                anchors.centerIn: parent
                visible: checkColumn
                checkState: {
                    var count = tableView.checkedIds.length;
                    if(count < 1) return Qt.Unchecked;
                    if(count < tableView.model.filterCount) return Qt.PartiallyChecked;
                    return Qt.Checked;
                }
            }
        }

        rowDelegate: Rectangle {
            height: 32
            color: tableView.currentRow === styleData.row || rowHandler.hovered ? Theme.table_row_hov_color : Theme.table_background_color
            HoverHandler {
                id: rowHandler
                enabled: true
            }
        }

        handle: Theme.scroll_handle
        scrollBarBackground: Theme.scroll_background
        decrementControl: Theme.scroll_decrement
        incrementControl: Theme.scroll_increment
        corner: Theme.scroll_corner

    }

    Component {
        id: textColumn
        TableViewColumn {
            delegate: Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: styleData.role === "indexable" ? styleData.row+1 : styleData.value
                font: Theme.text_font
                elide: Text.ElideRight
                color: Theme.text_dark_color
            }
        }
    }

    Component {
        id: imageColumn
        TableViewColumn {
            delegate: Image {
                fillMode: Image.PreserveAspectFit
                source: styleData.value
            }
        }
    }

    Component {
        id: operateColumn
        TableViewColumn {
            delegate: Item {
                anchors.fill: parent
                Zutton {
                    anchors.centerIn: parent
                    normalImage: {
                        if(styleData.role === "watch") return "images/watch.png";
                        if(styleData.role === "edit") return "images/edit.png";
                        if(styleData.role === "del") return "images/del.png";
                        return "";
                    }
                    hoveredImage: {
                        if(styleData.role === "watch") return "images/watch_hover.png";
                        if(styleData.role === "edit") return "images/edit_hover.png";
                        if(styleData.role === "del") return "images/del_hover.png";
                        return "";
                    }
                    onClicked: {
                        tableView.operateRow(styleData.value, styleData.role);
                    }
                }
            }
        }
    }

    Component {
        id: checkBoxColumn
        TableViewColumn {
            delegate: Item {
                anchors.fill: parent
                ZheckBox {
                    id: rowCheckBox
                    anchors.centerIn: parent
                    checkState: tableView.checkedIds.includes(styleData.value)?Qt.Checked : Qt.Unchecked
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var tmps = tableView.checkedIds;
                        if(rowCheckBox.checkState) {
                            tmps = tmps.filter(el => el !== styleData.value);
                        }
                        else {
                            tmps.push(styleData.value);
                        }
                        tableView.checkedIds = tmps;
                    }
                }
            }
        }
    }

    function updateViewColumn() {
        while (tableView.columnCount > 0) {
            tableView.removeColumn(0);
        }
        var columnCount = sourceModel.columnCount();
        for(var col=0; col<columnCount; ++col) {
            var viewColumn = null;
            var tableColumn = sourceModel.columnData(col);
            switch(tableColumn.type) {
            case TableModel.Text:
                viewColumn = textColumn.createObject(tableView);
                break;
            case TableModel.Image:
                viewColumn = imageColumn.createObject(tableView);
                break;
            case TableModel.Operate:
                viewColumn = operateColumn.createObject(tableView);
                break;
            case TableModel.CheckBox:
                viewColumn = checkBoxColumn.createObject(tableView);
            }
            viewColumn.role = tableColumn.role;
            viewColumn.title = tableColumn.name;
            viewColumn.visible = true;
            viewColumn.width = tableColumn.width;
            viewColumn.resizable = tableColumn.resizable;
            viewColumn.movable = false;
            tableView.addColumn(viewColumn);
        }
    }
    Component.onCompleted: updateViewColumn()
}
