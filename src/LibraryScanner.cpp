#include "../include/LibraryScanner.h"
#include "../include/MetadataReader.h"
#include <QDir>
#include <QFileInfo>
#include <QDebug>

LibraryScanner::LibraryScanner(QObject *parent) : QObject(parent) {}

void LibraryScanner::scanDirectory(const QString& directoryPath) {
    scanDirectories({directoryPath});
}

void LibraryScanner::scanDirectories(const QStringList& directoryPaths) {
    emit scanStarted();
    
    int totalDirs = directoryPaths.size();
    int currentDir = 0;
    
    foreach (const QString& directoryPath, directoryPaths) {
        currentDir++;
        emit scanProgress((currentDir * 100) / totalDirs);
        
        QStringList musicFiles = getMusicFiles(directoryPath);
        if (musicFiles.isEmpty()) {
            emit errorOccurred(tr("No music files found in: %1").arg(directoryPath));
            continue;
        }
        
        MetadataReader reader;
        foreach (const QString& filePath, musicFiles) {
            Metadata metadata = reader.readMetadata(filePath);
            if (metadata.isValid()) {
                emit trackFound(metadata);
            } else {
                emit errorOccurred(tr("Failed to read metadata from: %1").arg(filePath));
            }
        }
    }
    
    emit scanFinished();
}

QStringList LibraryScanner::getMusicFiles(const QString& directoryPath) const {
    QStringList musicFiles;
    QDir directory(directoryPath);
    
    if (!directory.exists()) {
        return musicFiles;
    }
    
    QStringList filters;
    filters << "*.mp3" << "*.flac" << "*.ogg" << "*.wav" << "*.m4a";
    
    QFileInfoList files = directory.entryInfoList(
        filters,
        QDir::Files | QDir::NoDotAndDotDot,
        QDir::Name
    );
    
    foreach (const QFileInfo& fileInfo, files) {
        if (isMusicFile(fileInfo.filePath())) {
            musicFiles << fileInfo.absoluteFilePath();
        }
    }
    
    // Recursively scan subdirectories
    QFileInfoList subDirs = directory.entryInfoList(
        QDir::Dirs | QDir::NoDotAndDotDot
    );
    
    foreach (const QFileInfo& subDir, subDirs) {
        musicFiles += getMusicFiles(subDir.absoluteFilePath());
    }
    
    return musicFiles;
}

bool LibraryScanner::isMusicFile(const QString& filePath) const {
    QString extension = QFileInfo(filePath).suffix().toLower();
    return QStringList({"mp3", "flac", "ogg", "wav", "m4a"}).contains(extension);
}