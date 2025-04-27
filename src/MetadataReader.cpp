#include "MetadataReader.h"
#include <taglib/fileref.h>
#include <taglib/tag.h>

Metadata MetadataReader::readMetadata(const QString &filePath) {
    Metadata meta;

    TagLib::FileRef file(filePath.toUtf8().constData());
    if (!file.isNull() && file.tag()) {
        TagLib::Tag *tag = file.tag();

        meta.title = QString::fromStdString(tag->title().to8Bit(true));
        meta.artist = QString::fromStdString(tag->artist().to8Bit(true));
        meta.album = QString::fromStdString(tag->album().to8Bit(true));
        meta.genre = QString::fromStdString(tag->genre().to8Bit(true));
        meta.year = tag->year();
        // meta.coverArtPath remains empty for now
    }

    return meta;
}
