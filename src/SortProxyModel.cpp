#include "../include/SortProxyModel.h"
#include "../include/TracksModel.h"

SortProxyModel::SortProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setDynamicSortFilter(true);
}

bool SortProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QVariant leftData = sourceModel()->data(left, sortRole());
    QVariant rightData = sourceModel()->data(right, sortRole());

    switch (sortRole()) {
    case TracksModel::DurationRole:
        return leftData.toInt() < rightData.toInt();
    case TracksModel::YearRole:
    case TracksModel::TrackNumberRole:
    case TracksModel::PlayCountRole:
        return leftData.toInt() < rightData.toInt();
    case TracksModel::LastPlayedRole:
        return leftData.toDateTime() < rightData.toDateTime();
    default:
        return leftData.toString().compare(rightData.toString(), Qt::CaseInsensitive) < 0;
    }
}
