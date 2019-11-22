#ifndef APPCORE_H
#define APPCORE_H

#include <QObject>
#include "models.h"
#include "configs.h"

class CAppCore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* config READ config CONSTANT)
    Q_PROPERTY(QObject* infoModel READ infoModel CONSTANT)
    Q_PROPERTY(QObject* statsModel READ statsModel CONSTANT)
public:
    explicit CAppCore(QObject* parent = Q_NULLPTR);
    ~CAppCore();

    QObject* config() const;
    QObject* infoModel() const;
    QObject* statsModel() const;

    void init();
    void updateInfomation();

    Q_INVOKABLE QString importExcel(const QString& filePath);
    Q_INVOKABLE void exportDocument(const QString& savePath, const QString& id);
    Q_INVOKABLE void exportExcel(const QString& savePath, const QJsonArray& ids, bool open = true);
    Q_INVOKABLE QString loadPhoto(const QString& source);
    Q_INVOKABLE QString savePhoto(const QString& id, const QString& url);
    Q_INVOKABLE void printExcel(const QJsonArray& ids);
    Q_INVOKABLE QString getAppDir() const;
    Q_INVOKABLE void exportTemplate(const QString& savePath);

private slots:
    void onRefreshData(const QList<CTableRow>& rowList);
    void onDeleteData(const QList<CTableRow>& rowList);

private:
    void initDetailModel();
    void initStatsModel();
    void updateStats();

    CAppConfig* m_config;
    CTableModel* m_infoModel;
    CTableModel* m_statsModel;
};

#endif
