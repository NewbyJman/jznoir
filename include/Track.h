#pragma once
#include <QString>

struct Track {
    QString title;
    QString artist;
    QString album;
    QString filePath;
    int duration = 0; // in ms
};

Q_PROPERTY(QString durationFormatted READ getDurationFormatted NOTIFY changed)
Q_PROPERTY(QString playCount READ getPlayCount NOTIFY changed)

signals:
    void changed();