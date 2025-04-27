#pragma once

#include <QObject>
#include <QStringList>

class LibraryManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList directories READ directories NOTIFY directoriesChanged)
    
public:
    explicit LibraryManager(QObject *parent = nullptr);
    
    QStringList directories() const;
    
public slots:
    void addDirectory(const QString& path);
    void removeDirectory(int index);
    void setDirectories(const QStringList& paths);
    void saveDirectories();
    void loadDirectories();
    
signals:
    void directoriesChanged();
    void scanRequested(const QStringList& directories);
    
private:
    QStringList m_directories;
    const QString SETTINGS_KEY = "musicDirectories";
};