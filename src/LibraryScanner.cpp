#include "LibraryScanner.h"
#include <QDir>
#include <QDebug>

LibraryScanner::LibraryScanner(QObject *parent) : QObject(parent) {}

void LibraryScanner::scanDirectory(const QString &path) {
    QDir dir(path);
    if (!dir.exists()) return;

    QStringList audioFiles;
    for (const QFileInfo &file : dir.entryInfoList(QDir::Files)) {
        if (file.suffix().toLower() == "mp3" || file.suffix().toLower() == "flac") {
            audioFiles.append(file.absoluteFilePath());
        }
    }
    emit filesFound(audioFiles);
}