#ifndef SQLITEWORK_H
#define SQLITEWORK_H

#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QMap>

class CSqliteWork
{
public:
    explicit CSqliteWork(const QString& dbFile, QString& error);
    ~CSqliteWork();

    /*
    * @breif 激活表格
    * 表格字段(id,value)
    */
    bool setActivedTable(const QString& name);
    // 查询所有数据
    bool selectAll(QMap<QString, QString>& data);
    // 插入数据
    void insert(const QMap<QString, QString>& data);
    // 删除数据
    void del(const QStringList& ids);

private:
    QSqlDatabase m_dataBase;
    QSqlQuery m_sqlQuery;
    QString m_activedTable;
};

#endif
