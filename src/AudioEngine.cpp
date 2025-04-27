#include "AudioEngine.h"
#include <vlc/vlc.h>
#include <QDebug>

AudioEngine::AudioEngine(QObject *parent) : QObject(parent) {
    instance = libvlc_new(0, nullptr);
    if (!instance) {
        qCritical() << "Failed to create VLC instance!";
        return;
    }

    mediaPlayer = libvlc_media_player_new(instance);
    if (!mediaPlayer) {
        qCritical() << "Failed to create VLC media player!";
        libvlc_release(instance);
        instance = nullptr;
    }
}

AudioEngine::~AudioEngine() {
    if (mediaPlayer) {
        libvlc_media_player_stop(mediaPlayer);
        libvlc_media_player_release(mediaPlayer);
        mediaPlayer = nullptr;
    }
    if (instance) {
        libvlc_release(instance);
        instance = nullptr;
    }
}

void AudioEngine::play(const QString &filePath) {
    if (!instance || !mediaPlayer) return;

    libvlc_media_t *media = libvlc_media_new_path(instance, filePath.toUtf8());
    if (!media) {
        qWarning() << "Failed to create media from path:" << filePath;
        return;
    }

    libvlc_media_player_set_media(mediaPlayer, media);
    libvlc_media_release(media);  // release media after setting (safe)
    libvlc_media_player_play(mediaPlayer);
}

void AudioEngine::pause() {
    if (mediaPlayer) {
        libvlc_media_player_pause(mediaPlayer);
    }
}

void AudioEngine::stop() {
    if (mediaPlayer) {
        libvlc_media_player_stop(mediaPlayer);
    }
}

void AudioEngine::setVolume(int volume) {
    if (mediaPlayer) {
        libvlc_audio_set_volume(mediaPlayer, volume);
    }
}

void AudioEngine::seek(int position) {
    if (mediaPlayer) {
        libvlc_media_player_set_time(mediaPlayer, position);
    }
}

qint64 AudioEngine::duration() const {
    return mediaPlayer ? libvlc_media_player_get_length(mediaPlayer) : 0;
}

qint64 AudioEngine::position() const {
    return mediaPlayer ? libvlc_media_player_get_time(mediaPlayer) : 0;
}
