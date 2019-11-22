#ifndef MODELS_H
#define MODELS_H

#include <QAbstractTableModel>
#include <QJsonObject>
#include <QSortFilterProxyModel>
#include <QJsonArray>

#define CHECKROLE "checkable"
#define INDEXROLE "indexable"
#define WATCHROLE "watch"
#define EDITROLE "edit"
#define DELROLE "del"

class CTableRow
{
public:
    void setId(const QString& id);
    const QString& id() const;

    void setData(const QVariantMap& data);
    const QVariantMap& getData() const;

    void setValue(const QString& role, const QVariant& data);
    QVariant value(const QString& role) const;

private:
    QString m_id;
    QVariantMap m_data;
};

class CTableModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(int rowCount READ rowCount NOTIFY rowCountChanged)
public:
    explicit CTableModel(QObject* parent = Q_NULLPTR);
    ~CTableModel();

    enum DelegateType
    {
        Text = 0,
        Image,
        Operate,
        CheckBox
    };
    Q_ENUM(DelegateType);

    struct TableColumn
    {
        QString role;
        QString name;
        DelegateType type = Text;
        int width = 52;
        bool resizable = true;
    };

    void init(const QList<TableColumn>& columnList, bool checkable, bool enableIndex, bool enableOper);

    void setRowList(const QList<CTableRow>& rowList);
    QPair<int,int> refreshRowList(const QList<CTableRow>& rowList);
    const QList<CTableRow>& rowList() const;
    CTableRow rowData(int row) const;

    Q_INVOKABLE void updateRow(const QString& id, const QJsonObject& data);
    Q_INVOKABLE void deleteRow(const QString& id);

    Q_INVOKABLE QString rowId(const QModelIndex& index) const;
    Q_INVOKABLE QJsonObject columnData(int column) const;
    Q_INVOKABLE QJsonObject rowData(const QString& id) const;

    int rowCount(const QModelIndex& parent = QModelIndex()) const Q_DECL_OVERRIDE;

    int columnCount(const QModelIndex& parent = QModelIndex()) const Q_DECL_OVERRIDE;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE;

    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;

signals:
    void refreshData(const QList<CTableRow>& rowList);
    void removeData(const QList<CTableRow>& rowList);
    void rowCountChanged();

private:

    QHash<int, QByteArray> m_hashRole;
    QList<TableColumn> m_columnList;
    QList<CTableRow> m_rowList;
};

class CFilterTableModel: public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QObject* source WRITE setSource READ source)
    Q_PROPERTY(QJsonArray range WRITE setRange READ range NOTIFY rangeChanged)
    Q_PROPERTY(QJsonArray filterValue WRITE setFilterValue READ filterValue NOTIFY filterValueChanged)
    Q_PROPERTY(int filterCount READ filterCount NOTIFY filterCountChanged)
public:
    explicit CFilterTableModel(QObject* parent = Q_NULLPTR);
    ~CFilterTableModel();

    QObject* source() const;
    void setSource(QObject* source);

    void setRange(const QJsonArray& value);
    const QJsonArray& range() const;

    void setFilterValue(const QJsonArray& value);
    const QJsonArray& filterValue() const;

    int filterCount() const;
    Q_INVOKABLE QJsonArray filterIds() const;

signals:
    void rangeChanged();
    void filterValueChanged();
    void filterCountChanged();

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const Q_DECL_OVERRIDE;
    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const Q_DECL_OVERRIDE;

protected slots:
    void onSourceChagned();

private:
    void updateFilter();
    bool filterContent(int source_row) const;
    bool filterPage(int source_row) const;

    QJsonArray m_range;
    QJsonArray m_filterValue;
};

#endif
