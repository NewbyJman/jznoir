#pragma once

#include <QSortFilterProxyModel>

class SortProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit SortProxyModel(QObject *parent = nullptr);

protected:
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;
};