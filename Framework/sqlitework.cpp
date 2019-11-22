#include "sqlitework.h"
#include <QCoreApplication>
#include <QDebug>
#include <QSqlError>

CSqliteWork::CSqliteWork(const QString& dbFile, QString& error)
{
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE");
    m_dataBase.setDatabaseName(dbFile);
    if (!m_dataBase.open())
    {
        error = QString("open ") + dbFile + "failed";
    }
    m_sqlQuery = QSqlQuery(m_dataBase);
}

CSqliteWork::~CSqliteWork()
{
    m_dataBase.close();
}

bool CSqliteWork::setActivedTable(const QString& name)
{
    QStringList tables = m_dataBase.tables();
    if (!tables.contains(name))
    {
        if (!m_sqlQuery.exec(QString("create table ") + name + "(id varchar primary key, value text)"))
        {
            return false;
        }
    }
    m_activedTable = name;
    return true;
}

bool CSqliteWork::selectAll(QMap<QString, QString>& data)
{
    data.clear();

    m_sqlQuery.exec("select * from " + m_activedTable);
    if (!m_sqlQuery.exec())
    {
        qDebug() << m_sqlQuery.lastError();
        return false;
    }
    while (m_sqlQuery.next())
    {
        data[m_sqlQuery.value(0).toString()] = m_sqlQuery.value(1).toString();
    }
    return true;
}

void CSqliteWork::insert(const QMap<QString, QString>& data)
{
    for (auto itr = data.begin(); itr != data.end(); ++itr)
    {
        QString statement = QString("insert into ") + m_activedTable + "(id,value)" + " values(\"" + itr.key() + "\", '" + *itr + "')";
        if (!m_sqlQuery.exec(statement))
        {
            qDebug() << m_sqlQuery.lastError();
            statement = QString("update ") + m_activedTable + " set value = '" + *itr + "' where id = \"" + itr.key() + "\"";
            m_sqlQuery.exec(statement);
            if (!m_sqlQuery.exec(statement))
            {
                qDebug() << m_sqlQuery.lastError();
            }
        }
    }
}

void CSqliteWork::del(const QStringList& ids)
{
    for (auto id : ids)
    {
        QString statement = QString("delete from ") + m_activedTable + " where id = \"" + id + "\"";
        m_sqlQuery.exec(statement);
        if (!m_sqlQuery.exec())
        {
            qDebug() << m_sqlQuery.lastError();
        }
    }
}
