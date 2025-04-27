#pragma once
#include <QObject>
#include <QQueue>
#include "metadata.h"

class QueueManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY queueChanged)
    Q_INVOKABLE void move(int from, int to);
    
public:
    explicit QueueManager(QObject* parent = nullptr);
    
    int count() const;
    Q_INVOKABLE Metadata get(int index) const;
    
public slots:
    void addToQueue(const QString& filePath);
    void addToQueue(const Metadata& track);
    void playNext(const QString& filePath);
    void playNext(const Metadata& track);
    void clear();
    void remove(int index);
    
signals:
    void queueChanged();
    void currentTrackChanged(const Metadata& track);
    
private:
    QQueue<Metadata> m_queue;
};