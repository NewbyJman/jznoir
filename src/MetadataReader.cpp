#include "../include/MetadataReader.h"
#include "../include/metadata.h"
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#include <QFileInfo>
#include <QImage>

MetadataReader::MetadataReader(QObject *parent) : QObject(parent) {}

Metadata MetadataReader::readMetadata(const QString &filePath) {
    Metadata metadata;
    metadata.filePath = filePath;
    
    TagLib::FileRef file(filePath.toStdString().c_str());
    
    if(file.isNull() || !file.tag()) {
        return metadata;
    }
    
    TagLib::Tag *tag = file.tag();
    
    metadata.title = QString::fromStdString(tag->title().to8Bit(true));
    metadata.artist = QString::fromStdString(tag->artist().to8Bit(true));
    metadata.album = QString::fromStdString(tag->album().to8Bit(true));
    metadata.genre = QString::fromStdString(tag->genre().to8Bit(true));
    metadata.trackNumber = tag->track();
    metadata.year = tag->year();
    metadata.duration = file.audioProperties()->length();
    
    // Album art extraction
    if(TagLib::MPEG::File *mpegFile = dynamic_cast<TagLib::MPEG::File*>(file.file())) {
        if(mpegFile->ID3v2Tag()) {
            auto frames = mpegFile->ID3v2Tag()->frameList("APIC");
            if(!frames.isEmpty()) {
                auto* picFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(frames.front());
                QImage coverArt;
                coverArt.loadFromData(
                    reinterpret_cast<const uchar*>(picFrame->picture().data()),
                    picFrame->picture().size()
                );
                
                if(!coverArt.isNull()) {
                    metadata.albumArt = QPixmap::fromImage(coverArt);
                    metadata.albumArtPath = QString("%1/cover_%2.png")
                        .arg(QFileInfo(filePath).absolutePath())
                        .arg(QString::fromStdString(tag->album().to8Bit(true)));
                    metadata.albumArt.save(metadata.albumArtPath, "PNG");
                }
            }
        }
    }
    
    // Default album art
    if(metadata.albumArt.isNull()) {
        metadata.albumArt = QPixmap("../qml/logo.png");
        metadata.albumArtPath = "../qml/logo.png";
    }
    
    return metadata;
}