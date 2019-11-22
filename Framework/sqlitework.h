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
    * @breif ������
    * ����ֶ�(id,value)
    */
    bool setActivedTable(const QString& name);
    // ��ѯ��������
    bool selectAll(QMap<QString, QString>& data);
    // ��������
    void insert(const QMap<QString, QString>& data);
    // ɾ������
    void del(const QStringList& ids);

private:
    QSqlDatabase m_dataBase;
    QSqlQuery m_sqlQuery;
    QString m_activedTable;
};

#endif
