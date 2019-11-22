#ifndef TOOLS_H
#define TOOLS_H

#include <QVariantList>
#include <QString>
#include <QSharedPointer>
#include "xlsxmediafile_p.h"

class XlsxTool
{
public:
    typedef QVariantList XlsxRow;
    typedef QSharedPointer<QXlsx::MediaFile> XlsxImage;

    static void getData(const QString& fileUrl, QList<XlsxRow>& xlxsRows, QMap<int, XlsxImage>& xlsxImages);

    static void saveData(const QString& saveFile, const QString& sheetName, const QList<QPair<QString, double>>& columnList,
                         const QList<QVector<QString>>& rowList, double rowHeight);

};

class WordTool
{
public:

    static bool saveInfomation(const QString& dotPath, const QVariantMap& roleData, const QPair<QString, QString>& photo, const QString& saveFile);
};

#endif
