#pragma once
#include <QObject>
#include <QStringList>

class LibraryScanner : public QObject {
    Q_OBJECT
public:
    explicit LibraryScanner(QObject *parent = nullptr);

public slots:
    void scanDirectory(const QString &path);

signals:
    void filesFound(const QStringList &filePaths);
};