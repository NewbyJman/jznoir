#pragma once
#include <QString>

struct Metadata {
    QString title;
    QString artist;
    QString album;
    QString genre;
    int year = 0;
    QString coverArtPath;
};

class MetadataReader {
public:
    static Metadata readMetadata(const QString &filePath);
};