import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import org.app.helpers 1.0

Popup {
    id: root
    modal: true
    focus: true
    closePolicy: Popup.NoAutoClose
    padding: 20
    width: 500
    height: 804

    property bool isEdit: false
    property string dataId

    onOpened: {
        if(!dataId) return;
        var rowData = appCore.infoModel.rowData(dataId);
        if(!rowData) return;
        nameRole.text = rowData.name;
        sexRole.currentIndex = sexRole.model.indexOf(rowData.sex);
        ageRole.text = rowData.age;
        regionRole.text = rowData.region;
        eduRole.text = rowData.edu;
        identityRole.text = rowData.identity;
        titleRole.text = rowData.title;
        telRole.text = rowData.tel;
        yearsRole.text = rowData.years;
        if(rowData.unit) unitRole.editText = rowData.unit;
        else unitRole.currentIndex = 0;
        eptypeRole.currentIndex = eptypeRole.model.indexOf(rowData.eptype);
        trainedRole.text = rowData.trained;
        scoreRole.text = rowData.score;
        contentRole.text = rowData.content;
        dualRole.currentIndex = eptypeRole.model.indexOf(rowData.dual);
        epnameRole.text = rowData.epname;
        if(rowData.place) placeRole.editText = rowData.place;
        else placeRole.currentIndex = 0;
        photoRole.source = "file:///"+appCore.getAppDir()+rowData.photo;
    }

    function submit() {
        if(!nameRole.text || !regionRole.text ||
                !unitRole.editText || !eptypeRole.currentText || !placeRole.editText) {
            return;
        }
        var infoId = identityRole.text;
        if(!infoId) {
            infoId = Qt.md5(new Date().toString());
        }
        console.log("工作单位",placeRole.editText);
        imageHelper.saveImage(appCore.getAppDir()+"/photos/"+infoId+".png");
        var data = {
            name: nameRole.text,
            sex: sexRole.currentText,
            age: ageRole.text,
            region: regionRole.text,
            edu: eduRole.text,
            identity: identityRole.text,
            title: titleRole.text,
            tel: telRole.text,
            years: yearsRole.text,
            unit: unitRole.editText,
            eptype: eptypeRole.currentText,
            trained: trainedRole.text,
            score: scoreRole.text,
            content: contentRole.text,
            dual: dualRole.currentText,
            epname: epnameRole.text,
            place: placeRole.editText,
            photo: "/photos/"+infoId+".png"
        }
        appCore.infoModel.updateRow(infoId,data);
        root.close();
    }

    FileDialog {
        id: fileDialog
        folder: shortcuts.desktop
        selectMultiple: false
        property int mode: 0
        onAccepted: {
            if(mode === 0) {
                photoRole.source = fileUrl;
            }
            else if( mode === 1) {
                appCore.exportDocument(fileUrl,dataId);
            }
        }
    }

    function importPhoto() {
        fileDialog.title = "请选择人物照片";
        fileDialog.selectFolder = false;
        fileDialog.selectExisting = true;
        fileDialog.nameFilters = [ "Image files (*.png *.jpg *.jpeg)"];
        fileDialog.mode = 0;
        fileDialog.open();
    }

    function saveAsWord() {
        if(dataId) {
            fileDialog.title = "请选择要保存的路径";
            fileDialog.selectFolder = false;
            fileDialog.selectExisting = false;
            fileDialog.nameFilters = [ "Word files (*.docx)"];
            fileDialog.mode = 1;
            fileDialog.open();
        }
    }

    onClosed: {
        dataId = "";
        isEdit = false;
        nameRole.text = "";
        sexRole.currentIndex = 0;
        ageRole.text = "";
        regionRole.text = "";
        eduRole.text = "";
        identityRole.text = "";
        titleRole.text = "";
        telRole.text = "";
        yearsRole.text = "";
        unitRole.currentIndex = 0;
        eptypeRole.currentIndex = 0;
        trainedRole.text = "";
        scoreRole.text = "";
        contentRole.text = "";
        dualRole.currentIndex = 0;
        epnameRole.text = "";
        placeRole.currentIndex = 0;
        photoRole.source = "";
    }


    contentItem: ColumnLayout {
        spacing: 20

        Label {
            Layout.fillWidth: true
            font: Theme.header_font
            text: qsTr("统计信息")
            Layout.alignment: Qt.AlignTop
            verticalAlignment: Text.AlignVCenter

            Zutton {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: -8
                anchors.rightMargin: -8
                normalImage: "images/close_hover.png"
                hoveredImage: "images/close_hover.png"
                onClicked: root.close()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: contentLayout.height

            ColumnLayout {
                id: contentLayout
                Layout.fillWidth: true
                spacing: 10
                RowLayout {
                    Layout.preferredHeight: 32
                    width: 200
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("姓名（必填）")
                        wrapMode: Text.WordWrap
                        color: nameRole.text ? "#000" : "red"
                    }
                    TextField {
                        id: nameRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200
                        font: Theme.text_font
                        enabled: root.isEdit
                        color: Theme.text_nor_color
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    width: 200
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("性别")
                    }
                    ComboBox {
                        id: sexRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 110
                        font: Theme.text_font
                        model: ["男","女"]
                        enabled: root.isEdit
                    }
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 42
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("年龄")
                    }
                    TextField {
                        id: ageRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        font: Theme.text_font
                        validator: IntValidator{bottom: 0; top: 200;}
                        enabled: root.isEdit
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    width: 200
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("所属地区（必填）")
                        wrapMode: Text.WordWrap
                        color: regionRole.text ? "#000" : "red"
                    }
                    TextField {
                        id: regionRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 110
                        font: Theme.text_font
                        enabled: root.isEdit
                    }
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 42
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("学历")
                    }
                    TextField {
                        id: eduRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        font: Theme.text_font
                        enabled: root.isEdit
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    width: 200
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("身份证号")
                        wrapMode: Text.WordWrap
                    }
                    TextField {
                        id: identityRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200
                        font: Theme.text_font
                        enabled: root.isEdit
                        validator: RegExpValidator { regExp: /[0-9A-z]+/ }
                        maximumLength: 18
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("职称")
                    }
                    TextField {
                        id: titleRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 150
                        font: Theme.text_font
                        enabled: root.isEdit
                    }
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 50
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("手机号")
                    }
                    TextField {
                        id: telRole
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font: Theme.text_font
                        enabled: root.isEdit
                        validator: RegExpValidator { regExp: /[0-9]+/ }
                        maximumLength: 12
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true
                    spacing: 12
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("从事统计工作的年限")
                        wrapMode: Text.WordWrap
                    }
                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            border.width: 1
                            border.color: "#BDBDBD"
                        }
                        TextArea {
                            id: yearsRole
                            font: Theme.text_font
                            readOnly: !root.isEdit
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    width: 200
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("工作单位（必填）")
                        wrapMode: Text.WordWrap
                        color: unitRole.editText ? "#000" : "red"
                    }
                    ComboBox {
                        id: unitRole
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font: Theme.text_font
                        editable: true
                        enabled: root.isEdit
                        model: ["仙桃市统计局", "统计站"]
                    }
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("企业类型（必填）")
                        wrapMode: Text.WordWrap
                        color: eptypeRole.currentText ? "#000" : "red"
                    }
                    ComboBox {
                        id: eptypeRole
                        Layout.fillHeight: true
                        Layout.preferredWidth: 110
                        font: Theme.text_font
                        model: ["工业","商贸","服务业","建筑业","房地产","投资"]
                        enabled: root.isEdit
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true
                    spacing: 12
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("何时何地参加过统计培训")
                        wrapMode: Text.WordWrap
                    }
                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            border.width: 1
                            border.color: "#BDBDBD"
                        }
                        TextArea {
                            id: trainedRole
                            font: Theme.text_font
                            readOnly: !root.isEdit
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 32
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("培训成绩")
                        wrapMode: Text.WordWrap
                    }
                    TextField {
                        id: scoreRole
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font: Theme.text_font
                        validator: DoubleValidator{bottom: 0.0; top: 100.0}
                        enabled: root.isEdit
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 96
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 60
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("培训内容")
                    }
                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            border.width: 1
                            border.color: "#BDBDBD"
                        }
                        TextArea {
                            id: contentRole
                            font: Theme.text_font
                            readOnly: !root.isEdit
                            wrapMode: Text.WordWrap
                        }
                    }

                }

                RowLayout {
                    Layout.preferredHeight: 32
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("是否会计兼统计")
                        wrapMode: Text.WordWrap
                    }
                    ComboBox {
                        id: dualRole
                        Layout.leftMargin: 12
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font: Theme.text_font
                        model: ["否","是"]
                        enabled: root.isEdit
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true
                    spacing: 12
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("兼职统计工作的企业名称")
                        wrapMode: Text.WordWrap
                    }
                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            border.width: 1
                            border.color: "#BDBDBD"
                        }
                        TextArea {
                            id: epnameRole
                            font: Theme.text_font
                            readOnly: !root.isEdit
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                RowLayout {
                    Layout.preferredHeight: 60
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 48
                        verticalAlignment: Text.AlignVCenter
                        font: Theme.text_font
                        text: qsTr("工作单位所属地（必填）")
                        wrapMode: Text.WordWrap
                        color: placeRole.editText ? "#000" : "red"
                    }
                    ComboBox {
                        id: placeRole
                        Layout.leftMargin: 12
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font: Theme.text_font
                        editable: true
                        model: ["仙桃市统计局","统计站"]
                        enabled: root.isEdit
                    }
                }
            }
            Rectangle {
                x: 270
                y: 0
                width: 190
                height: 158
                border.width: 1
                border.color: hoverHandler.hovered ? Theme.border_hov_color : "#ececec"

                Image {
                    id: photoRole
                    anchors.fill: parent
                    cache: false
                    fillMode: Image.PreserveAspectFit
                    onSourceChanged: imageHelper.loadImage(source)
                    ImageHelper {
                        id: imageHelper
                    }
                }

                Zutton {
                    anchors.centerIn: parent
                    visible: hoverHandler.hovered
                    normalImage: "qrc:/qmls/images/tianjia.png"
                    hoveredImage: "qrc:/qmls/images/tianjia_hover.png"
                    text: "像素358*441"
                    onClicked: {
                        if(root.isEdit) {
                            root.importPhoto();
                        }
                    }
                }

                HoverHandler {
                    id: hoverHandler
                }
            }
        }

        Button {
            Layout.preferredHeight: 32
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignHCenter
            font: Theme.text_font
            text: root.isEdit ? "提交" : "打印"
            onClicked: {
                if(root.isEdit) {
                    root.submit();
                }
                else {
                    root.saveAsWord();
                }
            }
        }
    }
}
