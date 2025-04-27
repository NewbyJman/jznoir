#pragma once

#include "metadata.h"
#include <QObject>
#include <QStringList>
#include <QThread>

class LibraryScanner : public QObject
{
    Q_OBJECT
public:
    explicit LibraryScanner(QObject *parent = nullptr);
    
public slots:
    void scanDirectory(const QString& directoryPath);
    void scanDirectories(const QStringList& directoryPaths);

signals:
    void trackFound(const Metadata& metadata);
    void scanStarted();
    void scanFinished();
    void scanProgress(int percent);
    void errorOccurred(const QString& error);

private:
    QStringList getMusicFiles(const QString& directoryPath) const;
    bool isMusicFile(const QString& filePath) const;
};