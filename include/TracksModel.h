#pragma once

#include "metadata.h"
#include <QAbstractListModel>

class TracksModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        FilePathRole = Qt::UserRole + 1,
        TitleRole,
        ArtistRole,
        AlbumRole,
        GenreRole,
        TrackNumberRole,
        YearRole,
        DurationRole,
        AlbumArtRole,
        PlayCountRole,
        LastPlayedRole
    };

    enum SortColumns {
        SortTitle = TitleRole,
        SortArtist = ArtistRole,
        SortAlbum = AlbumRole,
        SortYear = YearRole,
        SortDuration = DurationRole,
        SortPlayCount = PlayCountRole
    };
    Q_ENUM(SortColumns)

    explicit TracksModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addTrack(const Metadata &metadata);
    void addTracks(const QList<Metadata> &tracks);
    void clear();

    Q_INVOKABLE void sortByColumn(SortColumns column, Qt::SortOrder order = Qt::AscendingOrder);
    Q_INVOKABLE Metadata getTrack(int index) const;

private:
    QList<Metadata> m_tracks;
};
