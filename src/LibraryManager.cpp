#include "../include/LibraryManager.h"
#include <QSettings>
#include <QStandardPaths>

LibraryManager::LibraryManager(QObject *parent) : QObject(parent) {
    loadDirectories();
}

QStringList LibraryManager::directories() const {
    return m_directories;
}

void LibraryManager::addDirectory(const QString& path) {
    if (!m_directories.contains(path)) {
        m_directories.append(path);
        emit directoriesChanged();
    }
}

void LibraryManager::removeDirectory(int index) {
    if (index >= 0 && index < m_directories.size()) {
        m_directories.removeAt(index);
        emit directoriesChanged();
    }
}

void LibraryManager::setDirectories(const QStringList& paths) {
    if (m_directories != paths) {
        m_directories = paths;
        emit directoriesChanged();
    }
}

void LibraryManager::saveDirectories() {
    QSettings settings;
    settings.setValue(SETTINGS_KEY, m_directories);
}

void LibraryManager::loadDirectories() {
    QSettings settings;
    m_directories = settings.value(SETTINGS_KEY).toStringList();
    emit directoriesChanged();
}