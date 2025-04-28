#include "../include/TracksModel.h"
#include <QDebug>
#include <QFileInfo>
#include <QTime>

TracksModel::TracksModel(QObject *parent) : QAbstractListModel(parent) {}

int TracksModel::rowCount(const QModelIndex &parent) const {
    return parent.isValid() ? 0 : m_tracks.size();
}

QVariant TracksModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_tracks.size())
        return QVariant();

    const Metadata &track = m_tracks.at(index.row());

    switch (role) {
    case FilePathRole: return track.filePath;
    case TitleRole: return track.title.isEmpty() ? QFileInfo(track.filePath).baseName() : track.title;
    case ArtistRole: return track.artist.isEmpty() ? "Unknown Artist" : track.artist;
    case AlbumRole: return track.album.isEmpty() ? "Unknown Album" : track.album;
    case GenreRole: return track.genre;
    case TrackNumberRole: return track.trackNumber;
    case YearRole: return track.year;
    case DurationRole: return QTime(0, 0).addSecs(track.duration).toString("mm:ss");
    case AlbumArtRole: return track.albumArt;
    case PlayCountRole: return track.playCount;
    case LastPlayedRole: return track.lastPlayed;
    default: return QVariant();
    }
}

QHash<int, QByteArray> TracksModel::roleNames() const {
    return {
        {FilePathRole, "filePath"},
        {TitleRole, "title"},
        {ArtistRole, "artist"},
        {AlbumRole, "album"},
        {GenreRole, "genre"},
        {TrackNumberRole, "trackNumber"},
        {YearRole, "year"},
        {DurationRole, "duration"},
        {AlbumArtRole, "albumArt"},
        {PlayCountRole, "playCount"},
        {LastPlayedRole, "lastPlayed"}
    };
}

void TracksModel::addTrack(const Metadata &metadata) {
    beginInsertRows(QModelIndex(), m_tracks.size(), m_tracks.size());
    m_tracks.append(metadata);
    endInsertRows();
}

void TracksModel::addTracks(const QList<Metadata> &tracks) {
    if (tracks.isEmpty()) return;

    beginInsertRows(QModelIndex(), m_tracks.size(), m_tracks.size() + tracks.size() - 1);
    m_tracks.append(tracks);
    endInsertRows();
}

void TracksModel::clear() {
    beginResetModel();
    m_tracks.clear();
    endResetModel();
}

void TracksModel::sortByColumn(SortColumns column, Qt::SortOrder order) {
    beginResetModel();
    std::sort(m_tracks.begin(), m_tracks.end(), [column, order](const Metadata& a, const Metadata& b) {
        switch (column) {
        case SortTitle:
            return order == Qt::AscendingOrder ? a.title < b.title : a.title > b.title;
        case SortArtist:
            return order == Qt::AscendingOrder ? a.artist < b.artist : a.artist > b.artist;
        case SortAlbum:
            return order == Qt::AscendingOrder ? a.album < b.album : a.album > b.album;
        case SortYear:
            return order == Qt::AscendingOrder ? a.year < b.year : a.year > b.year;
        case SortDuration:
            return order == Qt::AscendingOrder ? a.duration < b.duration : a.duration > b.duration;
        case SortPlayCount:
            return order == Qt::AscendingOrder ? a.playCount < b.playCount : a.playCount > b.playCount;
        default:
            return false;
        }
    });
    endResetModel();
}

Metadata TracksModel::getTrack(int index) const {
    if (index >= 0 && index < m_tracks.size())
        return m_tracks.at(index);
    return Metadata();
}