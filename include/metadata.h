#pragma once

#include <QString>
#include <QPixmap>
#include <QDateTime>

struct Metadata {
    QString filePath;
    QString title;
    QString artist;
    QString album;
    QString genre;
    int trackNumber;
    int year;
    int duration; // in seconds
    QPixmap albumArt;
    QString albumArtPath;
    int playCount = 0;
    QDateTime lastPlayed;
    
    bool isValid() const {
        return !filePath.isEmpty() && duration > 0;
    }
    
    bool operator==(const Metadata& other) const {
        return filePath == other.filePath;
    }
};