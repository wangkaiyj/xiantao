#include "tools.h"
#include "xlsxdocument.h"
#include "xlsxworkbook.h"
#include "xlsxmediafile_p.h"

#include <QDebug>
#include <QAxObject>

void XlsxTool::getData(const QString& fileUrl, QList<XlsxRow>& xlxsRows, QMap<int, XlsxImage>& xlsxImages)
{
    xlxsRows.clear();
    xlsxImages.clear();
    QXlsx::Document xlsx(fileUrl);
    QXlsx::CellRange dimension = xlsx.dimension();
    int rowCount = dimension.rowCount();
    int columnCount = dimension.columnCount();
    for (auto i = 0; i < rowCount; ++i)
    {
        XlsxRow data;
        for (auto j = 0; j < columnCount; ++j)
        {
            data.push_back(xlsx.read(dimension.firstRow() + i, dimension.firstColumn() + j));
        }
        xlxsRows.push_back(data);
    }
    /*QXlsx::Workbook* workbook = xlsx.workbook();
    mediaFiles = workbook->mediaFiles();*/
}

void XlsxTool::saveData(const QString& saveFile, const QString& sheetName, const QList<QPair<QString, double>>& columnList,
                        const QList<QVector<QString>>& rowList, double rowHeight)
{
    QXlsx::Document xlsx;
    xlsx.addSheet(sheetName);
    if (!xlsx.selectSheet(sheetName))
    {
        return;
    }
    QXlsx::Format format;
    format.setHorizontalAlignment(QXlsx::Format::AlignHCenter);
    format.setVerticalAlignment(QXlsx::Format::AlignVCenter);
    for (int col = 0; col < columnList.length(); ++col)
    {
        xlsx.write(1, col + 1, columnList[col].first, format);
        xlsx.setColumnWidth(col + 1, columnList[col].second);
        xlsx.setRowHeight(1, rowHeight);
    }
    for (int row = 0; row < rowList.length(); ++row)
    {
        QVector<QString> dataList = rowList[row];
        for (int col = 0; col < dataList.length(); ++col)
        {
            xlsx.write(row + 2, col + 1, dataList[col], format);
            xlsx.setRowHeight(row + 2, rowHeight);
        }
    }
    xlsx.saveAs(saveFile);
}

//////////////////////////////////////////////////////////////////////////

bool WordTool::saveInfomation(const QString& dotPath, const QVariantMap& roleData, const QPair<QString, QString>& photo, const QString& saveFile)
{
    struct stWordHolder
    {
        ~stWordHolder()
        {
            if (activeDocument)
            {
                activeDocument->dynamicCall("Close (bool)", true);
            }
            if (instance)
            {
                instance->dynamicCall("Quit()");
            }
            if (activeDocument)
            {
                delete activeDocument;
            }
            if (instance)
            {
                delete instance;
            }
        }

        QAxObject* instance = nullptr;
        QAxObject* activeDocument = nullptr;
    };
    stWordHolder wordHolder;
    // 实例化
    wordHolder.instance = new QAxObject();
    bool bFlag = wordHolder.instance->setControl("word.Application");
    if (!bFlag)
    {
        bFlag = wordHolder.instance->setControl("kwps.Application");
        if (!bFlag)
        {
            return false;
        }
    }
    wordHolder.instance->setProperty("Visible", false);
    // 获取所有的工作文档
    QAxObject* document = wordHolder.instance->querySubObject("Documents");
    if (!document)
    {
        return false;
    }
    // 以文件dot文件为模版新建一个文档
    document->dynamicCall("Add(QString)", dotPath);
    // 获取当前激活的文档
    wordHolder.activeDocument = wordHolder.instance->querySubObject("ActiveDocument");
    // 插入数据
    for (auto itr = roleData.begin(); itr != roleData.end(); ++itr)
    {
        QAxObject* bookmarkCode = wordHolder.activeDocument->querySubObject("Bookmarks(QVariant)", itr.key());
        if(!bookmarkCode) continue;
        bookmarkCode->dynamicCall("Select(void)");
        bookmarkCode->querySubObject("Range")->setProperty("Text", itr.value());
    }
    if (!photo.first.isEmpty() && !photo.second.isEmpty())
    {
        QAxObject* bookmark = wordHolder.activeDocument->querySubObject("Bookmarks(QVariant)", photo.first);
        // 选中标签，将图片插入到标签位置
        if (bookmark)
        {
            bookmark->dynamicCall("Select(void)");
            QAxObject* selection = wordHolder.instance->querySubObject("Selection");
            selection->querySubObject("ParagraphFormat")->dynamicCall("Alignment", "wdAlignParagraphCenter");
            QAxObject *range = bookmark->querySubObject("Range");
            QList<QVariant>qList;
            qList << photo.second;
            qList << false;
            qList << true;
            qList << range->asVariant();
            QAxObject *Inlineshapes = wordHolder.activeDocument->querySubObject("InlineShapes");
            Inlineshapes->dynamicCall("AddPicture(const QString&, QVariant, QVariant ,QVariant)", qList);
        }
    }

    // 保存
    wordHolder.activeDocument->dynamicCall("SaveAs (const QString&)", saveFile).toBool();

    return true;
}
