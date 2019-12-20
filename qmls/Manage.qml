import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

Page {
    id: root

    FileDialog {
        id: fileDialog
        folder: shortcuts.desktop
        selectMultiple: false
        nameFilters: [ "Excel files (*.xlsx)"]
        property var mode: -1
        onAccepted: {
            if(mode === 0) {
                var msg = appCore.importExcel(fileUrl);
                importToolTip.show(msg, 4000);
            }
            else if(mode == 1) {
                appCore.exportExcel(fileUrl,tableView.checkedIds);
            }
            else if(mode == 2) {
                appCore.exportTemplate(fileUrl);
            }
        }
    }

    background: Item {

    }

    Infomation {
        id: infomation
        anchors.centerIn: parent
    }

    header: ToolBar {
        id: control
        padding: 10
        background: Rectangle {
            implicitHeight: 74
            color: "transparent"
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.border_nor_color
            }
        }

        ColumnLayout {
            width: parent.width
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                spacing: 20
                ZearchBox {
                    id: searchName
                    Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "名称关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchIdentity
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "身份证号关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchSex
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "性别关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchAge
                    Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "年龄关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchEdu
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "学历关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                Zutton {
                    normalImage: "images/exceltemplate.png"
                    hoveredImage: "images/exceltemplate_hover.png"
                    Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    text: "模板"
                    onClicked: {
                        fileDialog.title = "请选择Excel文档";
                        fileDialog.selectFolder = false;
                        fileDialog.selectExisting = false;
                        fileDialog.mode = 2;
                        fileDialog.open();
                    }
                }

                Zutton {
                    normalImage: "images/add.png"
                    hoveredImage: "images/add_hover.png"
                    Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    text: "增加"
                    onClicked: {
                        infomation.dataId = "";
                        infomation.isEdit = true;
                        infomation.open()
                    }
                }
                Zutton {
                    normalImage: "images/import.png"
                    hoveredImage: "images/import_hover.png"
                    Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    text: "导入"
                    onClicked: {
                        fileDialog.title = "请选择Excel文档";
                        fileDialog.selectFolder = false;
                        fileDialog.selectExisting = true;
                        fileDialog.mode = 0;
                        fileDialog.open();
                    }
                    ToolTip {
                        id: importToolTip
                    }
                }
                Zutton {
                    normalImage: "images/export.png"
                    hoveredImage: "images/export_hover.png"
                    Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    text: "导出"
                    onClicked: {
                        fileDialog.title = "请选择要保存的路径";
                        fileDialog.selectFolder = false;
                        fileDialog.selectExisting = false;
                        fileDialog.mode = 1;
                        fileDialog.open();
                    }
                }
                Zutton {
                    normalImage: "images/print.png"
                    hoveredImage: "images/print_hover.png"
                    Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    text: "打印"
                    onClicked: {
                        appCore.printExcel(tableView.checkedIds);
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                spacing: 20

                ZearchBox {
                    id: searchTitle
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "职称关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchYears
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "统计工作年限关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchUnit
                    Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "工作单位关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchTel
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "手机号关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchPlace
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "工作单位所属地关键字..."
                }

                Item {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 20
                }

                ZearchBox {
                    id: searchEptype
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 220
                    placeholderText: "企业类型关键字..."
                }
            }
        }
    }

    SplitView {
        anchors.fill: parent

        handle: Rectangle {
            implicitWidth: 4
            color: Theme.border_nor_color
        }

        Item {
            SplitView.fillHeight: true
            SplitView.minimumWidth: 120

            ListView {
                id: regionView
                anchors.fill: parent
                anchors.margins: 1
                clip: true
                model: appCore.config.regions
                currentIndex: 0

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 32
                    color: regionView.currentIndex === index || regionArea.containsMouse ? Theme.table_row_hov_color : Theme.table_background_color
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: modelData
                        color: regionView.currentIndex === index || regionArea.containsMouse ? Theme.text_dark_color : Theme.text_light_color
                    }

                    MouseArea {
                        id: regionArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if(regionView.currentIndex !== index) {
                                regionView.currentIndex = index;
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            SplitView.minimumWidth: 400
            color: Theme.table_background_color
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                ZableView {
                    id: tableView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 1
                    sourceModel: appCore.infoModel
                    startRow: pageBar.curPage*pageBar.pageCount
                    filterValue: [{"roles":["name"],"value":searchName.text},{"roles":["identity"],"value":searchIdentity.text},{"roles":["sex"],"value":searchSex.text},
                        {"roles":["age"],"value":searchAge.text},{"roles":["edu"],"value":searchEdu.text},{"roles":["title"],"value":searchTitle.text},{"roles":["years"],"value":searchYears.text},
                        {"roles":["unit"],"value":searchUnit.text},{"roles":["tel"],"value":searchTel.text},{"roles":["place"],"value":searchPlace.text},{"roles":["eptype"],"value":searchEptype.text},
                        {"roles":["region"],"value":(regionView.currentIndex<=0?"" : regionView.model[regionView.currentIndex])}]
                    endRow: startRow+pageBar.pageCount-1
                    onOperateRow: {
                        if(role === "watch") {
                            infomation.dataId = id;
                            infomation.isEdit = false;
                            infomation.open();
                            return;
                        }
                        if(role === "edit") {
                            infomation.dataId = id;
                            infomation.isEdit = true;
                            infomation.open();
                            return;
                        }
                        if(role === "del") {
                            appCore.infoModel.deleteRow(id);
                            return;
                        }
                    }
                }

                PageBar {
                    id: pageBar
                    Layout.fillWidth: true
                    Layout.rightMargin: 10
                    Layout.preferredHeight: 48
                    pageCount: 50
                    totalCount: tableView.model.filterCount
                }
            }

        }
    }
}
