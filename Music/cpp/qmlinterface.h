#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QString>
#include <QDebug>
#include <QDir>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QMediaMetaData>
#include <QStandardPaths>


class QmlInterface : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDir path MEMBER m_musicPath)

public:
    explicit QmlInterface(QObject *parent = nullptr, QQmlApplicationEngine * engine = nullptr);

    Q_INVOKABLE QVariantList getAllAudioFiles();

    Q_INVOKABLE QDir getMusicPath();

    Q_INVOKABLE void setMusicPath(QString path);

    Q_INVOKABLE void startPlaying();

    Q_INVOKABLE void pausePlaying();

    Q_INVOKABLE void stopPlaying();

    Q_INVOKABLE void playNext();

    Q_INVOKABLE void playPrevious();

    Q_INVOKABLE void removeFromPlaylist(int index);

    Q_INVOKABLE void setShuffle(bool state);

    Q_INVOKABLE void setPlaybackMode(int mode);

    Q_INVOKABLE void setPlayingState(bool state);

    Q_INVOKABLE void setCurrentIndex(int index);

    Q_INVOKABLE int getCurrentMusicIndex();

    void getMetaData(QMediaPlayer * player);


private:
    QQmlApplicationEngine *m_engine;

    QDir m_musicPath;

    QVariantList _music;

    QMediaPlayer * player;

    QMediaPlaylist * playlist;

    QVariantList m_artistArray, m_lengthArray, m_albumArray, m_titleArray;

    int m_currentMusicIndex = 0, m_repeatIndex = 0;

    bool m_isMusicPlaying = false, m_isMusicPaused = false, m_isShuffleEnabled = false;

signals:
    void currentMusicIndexChanged();

    void musicIndexChanged();

    void shuffleChanged();

    void repeatChanged();

    void musicListSizeChanged(QVariantList data);

    void playerPositionChanged(int data);

    void musicDurationChanged(int data);

private slots:
    void onCurrentMusicIndexChanged();

    void onCurrentPlayerPositionChanged(int data);

    void onCurrentMediaStatusChanged(QMediaPlayer::MediaStatus status);
};

#endif // QMLINTERFACE_H
