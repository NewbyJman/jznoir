#pragma once
#include <QString>

struct Track {
    QString title;
    QString artist;
    QString album;
    QString filePath;
    int duration = 0; // in ms
};