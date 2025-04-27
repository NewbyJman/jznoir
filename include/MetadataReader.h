#pragma once

#include "metadata.h"
#include <QObject>

class MetadataReader : public QObject
{
    Q_OBJECT
public:
    explicit MetadataReader(QObject *parent = nullptr);
    Metadata readMetadata(const QString &filePath);
    
signals:
    void metadataRead(const Metadata &metadata);
    void errorOccurred(const QString &error);
};