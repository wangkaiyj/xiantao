#ifndef CONFIGS_H
#define CONFIGS_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QMap>

class CAppConfig : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray regions READ regions CONSTANT)
public:
    explicit CAppConfig(QObject* parent = Q_NULLPTR);
    ~CAppConfig();

    void init();

    const QJsonArray& regions() const;

    int itemXlsxHeight() const;
    const QJsonArray& itemColumns() const;
    QString getItemRole(const QString& name) const;

    int statsColWidth() const;
    const QJsonArray& statsColumns() const;

private:
    QJsonArray m_regions;
    int m_xlsxHeight = 0;
    QJsonArray m_itemColumns;
    int m_statsColWidth = 0;
    QJsonArray m_statsColumns;
};

#endif