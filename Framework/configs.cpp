#include "configs.h"
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>

CAppConfig::CAppConfig(QObject* parent)
    : QObject(parent)
{

}

CAppConfig::~CAppConfig()
{

}

void CAppConfig::init()
{
    QFile file = ":/qmls/config/config.json";
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &error);
        if (error.error != QJsonParseError::NoError)
        {
            qDebug() << error.errorString();
        }
        else
        {
            QJsonObject root = doc.object();
            m_regions = root.value("regions").toArray();
            QJsonObject itemTemplate = root.value("itemTemplate").toObject();
            m_xlsxHeight = itemTemplate.value("xlsxHeight").toInt();
            m_itemColumns = itemTemplate.value("columns").toArray();
            QJsonObject statsTemplate = root.value("statsTemplate").toObject();
            m_statsColWidth = statsTemplate.value("colWidth").toInt();
            m_statsColumns = statsTemplate.value("columns").toArray();
        }
    }
}

const QJsonArray& CAppConfig::regions() const
{
    return m_regions;
}

int CAppConfig::itemXlsxHeight() const
{
    return m_xlsxHeight;
}

const QJsonArray& CAppConfig::itemColumns() const
{
    return m_itemColumns;
}

QString CAppConfig::getItemRole(const QString& name) const
{
    for (auto val : m_itemColumns)
    {
        QJsonObject obj = val.toObject();
        if (obj.value("name").toString() == name)
        {
            return obj.value("role").toString();
        }
    }
    return "";
}

int CAppConfig::statsColWidth() const
{
    return m_statsColWidth;
}

const QJsonArray& CAppConfig::statsColumns() const
{
    return m_statsColumns;
}
