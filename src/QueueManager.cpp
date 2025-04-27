#include "../include/QueueManager.h"
#include "../include/MetadataReader.h"

QueueManager::QueueManager(QObject* parent) : QObject(parent) {}

int QueueManager::count() const {
    return m_queue.size();
}

void QueueManager::move(int from, int to) {
    if (from < 0 || from >= m_queue.size() || 
        to < 0 || to >= m_queue.size() || from == to) {
        return;
    }

    beginResetModel();
    m_queue.move(from, to);
    endResetModel();
    emit queueChanged();
}

Metadata QueueManager::get(int index) const {
    if (index >= 0 && index < m_queue.size())
        return m_queue.at(index);
    return Metadata();
}

void QueueManager::addToQueue(const QString& filePath) {
    MetadataReader reader;
    addToQueue(reader.readMetadata(filePath));
}

void QueueManager::addToQueue(const Metadata& track) {
    if (!track.isValid()) return;
    
    beginInsertRows(QModelIndex(), m_queue.size(), m_queue.size());
    m_queue.enqueue(track);
    endInsertRows();
    emit queueChanged();
}

void QueueManager::playNext(const QString& filePath) {
    MetadataReader reader;
    playNext(reader.readMetadata(filePath));
}

void QueueManager::playNext(const Metadata& track) {
    if (!track.isValid()) return;
    
    m_queue.prepend(track);
    emit queueChanged();
}

void QueueManager::clear() {
    if (m_queue.isEmpty()) return;
    
    beginResetModel();
    m_queue.clear();
    endResetModel();
    emit queueChanged();
}

void QueueManager::remove(int index) {
    if (index < 0 || index >= m_queue.size()) return;
    
    beginRemoveRows(QModelIndex(), index, index);
    m_queue.removeAt(index);
    endRemoveRows();
    emit queueChanged();
}