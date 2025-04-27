#pragma once

#include <QObject>
#include <QString>

struct libvlc_instance_t;
struct libvlc_media_player_t;

class AudioEngine : public QObject {
    Q_OBJECT
public:
    explicit AudioEngine(QObject *parent = nullptr);
    ~AudioEngine();

    void play(const QString &filePath);
    void pause();
    void stop();
    void setVolume(int volume);
    void seek(int position);
    qint64 duration() const;
    qint64 position() const;

private:
    libvlc_instance_t *instance = nullptr;
    libvlc_media_player_t *mediaPlayer = nullptr;
};
