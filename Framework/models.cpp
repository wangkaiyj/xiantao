#include "models.h"
#include <QDebug>

void CTableRow::setId(const QString& id)
{
    m_id = id;
}

const QString& CTableRow::id() const
{
    return m_id;
}

void CTableRow::setData(const QVariantMap& data)
{
    m_data = data;
}

const QVariantMap& CTableRow::getData() const
{
    return m_data;
}

void CTableRow::setValue(const QString& role, const QVariant& data)
{
    m_data[role] = data;
}

QVariant CTableRow::value(const QString& role) const
{
    return m_data.value(role);
}

//////////////////////////////////////////////////////////////////////////
CTableModel::CTableModel(QObject* parent)
    : QAbstractTableModel(parent)
{

}

CTableModel::~CTableModel()
{

}

void CTableModel::init(const QList<TableColumn>& columnList, bool checkable, bool enableIndex, bool enableOper)
{
    m_columnList.clear();
    m_hashRole.clear();
    int curRole = Qt::UserRole;
    if (checkable)
    {
        m_hashRole[curRole] = CHECKROLE;
        m_columnList.push_back({ CHECKROLE, "", CheckBox, 32, false });
    }
    if (enableIndex)
    {
        m_hashRole[++curRole] = INDEXROLE;
        m_columnList.push_back({ INDEXROLE, u8"ÐòºÅ", Text, 48, false });
    }
    for (auto i = 0; i < columnList.length(); ++i)
    {
        m_columnList.push_back(columnList[i]);
        m_hashRole[++curRole] = columnList[i].role.toUtf8();
    }
    if (enableOper)
    {
        m_hashRole[++curRole] = WATCHROLE;
        m_columnList.push_back({ WATCHROLE, u8"", Operate, 32, false });
        m_hashRole[++curRole] = EDITROLE;
        m_columnList.push_back({ EDITROLE, u8"", Operate, 32, false });
        m_hashRole[++curRole] = DELROLE;
        m_columnList.push_back({ DELROLE, u8"", Operate, 32, false });
    }
}

void CTableModel::setRowList(const QList<CTableRow>& rowList)
{
    beginResetModel();
    m_rowList = rowList;
    endResetModel();
    emit rowCountChanged();
}

QPair<int, int> CTableModel::refreshRowList(const QList<CTableRow>& rowList)
{
    QList<CTableRow> newList;
    for (auto& rowData : rowList)
    {
        auto itr = std::find_if(m_rowList.begin(), m_rowList.end(), [&rowData](const CTableRow & lhs)
        {
            return rowData.id() == lhs.id();
        });
        if (itr == m_rowList.end())
        {
            newList.push_back(rowData);
            continue;
        }
        int row = itr - m_rowList.begin();

        itr->setData(rowData.getData());
        QModelIndex topLeft = index(row, 0);
        QModelIndex bottomRight = index(row, columnCount() - 1);
        emit dataChanged(topLeft, bottomRight, m_hashRole.keys().toVector());
    }
    if (!newList.isEmpty())
    {
        beginInsertRows(QModelIndex(), 0, newList.count() - 1);
        std::for_each(newList.rbegin(), newList.rend(), [this](const CTableRow & rowData)
        {
            m_rowList.push_front(rowData);
        });
        endInsertRows();
    }

    emit refreshData(rowList);
    emit rowCountChanged();

    return {newList.length(), rowList.length() - newList.length()};
}

const QList<CTableRow>& CTableModel::rowList() const
{
    return m_rowList;
}

void CTableModel::updateRow(const QString& id, const QJsonObject& data)
{
    CTableRow tableRow;
    tableRow.setId(id);
    tableRow.setData(data.toVariantMap());
    refreshRowList({ tableRow });
}

void CTableModel::deleteRow(const QString& id)
{
    auto itr = std::find_if(m_rowList.begin(), m_rowList.end(), [&id](const CTableRow & row)
    {
        return row.id() == id;
    });
    if (itr != m_rowList.end())
    {
        CTableRow tableRow = *itr;
        int row = itr - m_rowList.begin();
        beginRemoveRows(QModelIndex(), row, row);
        m_rowList.erase(itr);
        endRemoveRows();
        emit removeData({ tableRow });
        emit rowCountChanged();
    }
}

QString CTableModel::rowId(const QModelIndex& index) const
{
    return m_rowList.value(index.row()).id();
}

QJsonObject CTableModel::columnData(int column) const
{
    if (column < 0 || column >= m_columnList.count())
    {
        return QJsonObject();
    }
    TableColumn tableColumn = m_columnList[column];
    return QJsonObject{ {"role", tableColumn.role}, {"name", tableColumn.name},
        {"width", tableColumn.width }, {"resizable", tableColumn.resizable}, {"sortable", tableColumn.sortable},
        {"type", tableColumn.type}
    };
}

CTableRow CTableModel::rowData(int row) const
{
    CTableRow tableRow;
    if (row >= 0 && row < m_rowList.length())
    {
        tableRow = m_rowList[row];
    }
    return m_rowList.value(row);
}

QJsonObject CTableModel::rowData(const QString& id) const
{
    QJsonObject retValue;
    auto itr = std::find_if(m_rowList.begin(), m_rowList.end(), [&id](const CTableRow & tableRow)
    {
        return tableRow.id() == id;
    });
    if (itr != m_rowList.end())
    {
        retValue = QJsonObject::fromVariantMap(itr->getData());
    }
    return retValue;
}

int CTableModel::rowCount(const QModelIndex& parent) const
{
    return m_rowList.count();
}

int CTableModel::columnCount(const QModelIndex& parent) const
{
    return m_columnList.count();
}

QVariant CTableModel::data(const QModelIndex &index, int role) const
{
    CTableRow tableRow = m_rowList.value(index.row());
    if (tableRow.id().isEmpty())
    {
        return QVariant();
    }
    QString strRole = m_hashRole.value(role);
    QVariant value = tableRow.value(strRole);
    return value.isValid() ? value : tableRow.id();
}

QHash<int, QByteArray> CTableModel::roleNames() const
{
    return m_hashRole;
}

void CTableModel::sort(const QString& role, bool desc)
{
    beginResetModel();
    std::stable_sort(m_rowList.begin(), m_rowList.end(), [role, desc](const CTableRow & lhs, const CTableRow & rhs)
    {
        QVariant ldata = lhs.value(role);
        QVariant rdata = rhs.value(role);
        bool isInt = false;
        ldata.toInt(&isInt);
        if (isInt)
        {
            isInt = false;
            rdata.toInt(&isInt);
        }
        if (isInt)
        {
            if (desc)
            {
                return ldata.toInt() > rdata.toInt();
            }
            else
            {
                return ldata.toInt() < rdata.toInt();
            }
        }
        else
        {
            if (desc)
            {
                return ldata.toString() > rdata.toString();
            }
            else
            {
                return ldata.toString() < rdata.toString();
            }
        }
    });
    endResetModel();
}

//////////////////////////////////////////////////////////////////////////
CFilterTableModel::CFilterTableModel(QObject* parent)
    : QSortFilterProxyModel(parent)
{

}

CFilterTableModel::~CFilterTableModel()
{

}

QObject *CFilterTableModel::source() const
{
    return sourceModel();
}

void CFilterTableModel::setSource(QObject *source)
{
    setSourceModel(qobject_cast<QAbstractItemModel *>(source));
    connect(source, SIGNAL(rowCountChanged()), SLOT(onSourceChagned()));
}

void CFilterTableModel::setRange(const QJsonArray& value)
{
    m_range = value;
    updateFilter();
    emit rangeChanged();
}

const QJsonArray& CFilterTableModel::range() const
{
    return m_range;
}

void CFilterTableModel::setFilterValue(const QJsonArray& value)
{
    m_filterValue = value;
    updateFilter();
    emit filterValueChanged();
}

const QJsonArray& CFilterTableModel::filterValue() const
{
    return m_filterValue;
}

int CFilterTableModel::filterCount() const
{
    CTableModel* tableModel = qobject_cast<CTableModel*>(sourceModel());
    if (!tableModel) return 0;
    int source_rows = tableModel->rowCount();
    int filter_rows = 0;
    for (int i = 0; i < source_rows; ++i)
    {
        if (filterContent(i))
        {
            ++filter_rows;
        }
    }
    return filter_rows;
}

QJsonArray CFilterTableModel::filterIds() const
{
    CTableModel* tableModel = qobject_cast<CTableModel*>(sourceModel());
    if (!tableModel) return QJsonArray();

    QList<CTableRow> rowList = tableModel->rowList();
    QJsonArray ids;
    int source_rows = tableModel->rowCount();
    int filter_rows = 0;
    for (int i = 0; i < source_rows; ++i)
    {
        if (filterContent(i))
        {
            ids.push_back(rowList[i].id());
            ++filter_rows;
        }
    }
    return ids;
}

void CFilterTableModel::setSortValue(const QJsonObject& value)
{
    m_sortValue = value;
    CTableModel* tableModel = qobject_cast<CTableModel*>(sourceModel());
    if (tableModel)
    {
        tableModel->sort(value.value("role").toString(), value.value("decs").toBool());
    }
    emit sortValueChanged();
}

const QJsonObject& CFilterTableModel::sortValue() const
{
    return m_sortValue;
}

void CFilterTableModel::updateFilter()
{
    setFilterRegExp(QRegExp(u8"**", filterCaseSensitivity(), QRegExp::PatternSyntax::Wildcard));
}

bool CFilterTableModel::filterContent(int source_row) const
{
    CTableModel* tableModel = qobject_cast<CTableModel*>(sourceModel());
    CTableRow tableRow = tableModel->rowData(source_row);
    bool contentOk = true;
    for (auto filter : m_filterValue)
    {
        QJsonObject filterobj = filter.toObject();
        QJsonArray roles = filterobj.value("roles").toArray();
        QString filter = filterobj.value("value").toString();
        contentOk = roles.isEmpty() ? true : false;
        for (auto role : roles)
        {
            QString value = tableRow.value(role.toString()).toString();
            if (value.contains(filter))
            {
                contentOk = true;
                break;
            }
        }
        if (!contentOk)
        {
            break;
        }
    }
    return contentOk;
}

bool CFilterTableModel::filterPage(int source_row) const
{
    if (m_range.size() != 2) return true;
    int endRow = m_range[1].toInt();
    if (endRow < 0) return true;

    int filter_row = -1;
    for (int row = 0; row <= source_row; ++row)
    {
        if (filterContent(row))
        {
            ++filter_row;
        }
    }
    return filter_row >= m_range[0].toInt() && filter_row <= endRow;
}

bool CFilterTableModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    CTableModel* tableModel = qobject_cast<CTableModel*>(sourceModel());
    if (!tableModel)
    {
        return QSortFilterProxyModel::filterAcceptsRow(source_row, source_parent);
    }

    return filterContent(source_row) && filterPage(source_row);
}

bool CFilterTableModel::lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const
{
    return __super::lessThan(source_left, source_right);
}

void CFilterTableModel::onSourceChagned()
{
    updateFilter();
    emit filterCountChanged();
}

