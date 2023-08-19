#include "qmlinterface.h"


QmlInterface::QmlInterface(QObject *parent, QQmlApplicationEngine * engine) : QObject(parent), m_engine(engine)
{
    player = new QMediaPlayer;

    playlist = new QMediaPlaylist;

    player->setVolume(50);

    player->setPlaylist(playlist);

    m_musicPath.setPath("C:/Users/ADMIN/Downloads/");

    connect(player, &QMediaPlayer::currentMediaChanged, this, &QmlInterface::onCurrentMusicIndexChanged);

    connect(player, &QMediaPlayer::positionChanged, this, &QmlInterface::onCurrentPlayerPositionChanged);

    connect(player, &QMediaPlayer::mediaStatusChanged, this, &QmlInterface::onCurrentMediaStatusChanged);

}

QVariantList QmlInterface::getAllAudioFiles()
{
    QDir directory(m_musicPath);
    _music.clear();
    QStringList music = directory.entryList(QStringList() << "*.mp3" << "*.MP3",QDir::Files);

    QList<QMediaContent> content;

    for(const QString& f:music)
    {
        content.push_back(QUrl::fromLocalFile(directory.path()+"/" + f));

        QFileInfo fi(f);

        _music.push_back(QVariant::fromValue(f));
    }
    playlist->addMedia(content);

    // m_musicPath = directory.path();

    return _music;
}

QDir QmlInterface::getMusicPath()
{
    return m_musicPath;
}

void QmlInterface::setMusicPath(QString path)
{
    m_musicPath.setPath(path);
}

void QmlInterface::startPlaying()
{
    player->play();
}

void QmlInterface::pausePlaying()
{
    player->pause();
}

void QmlInterface::stopPlaying()
{
    player->stop();
}

void QmlInterface::playNext()
{
    playlist->next();
}

void QmlInterface::playPrevious()
{
    playlist->previous();
}

void QmlInterface::removeFromPlaylist(int index)
{
    playlist->removeMedia(index);

    _music.removeAt(index);

    emit musicListSizeChanged(_music);
}

void QmlInterface::setShuffle(bool state)
{
    if(state)
    {
        if(m_repeatIndex!=0)
            m_repeatIndex = 0;

        playlist->setPlaybackMode(QMediaPlaylist::Random);

        m_isShuffleEnabled = true;
    }

    else
    {
        m_isShuffleEnabled = true;

        playlist->setPlaybackMode(QMediaPlaylist::Sequential);
    }
}

void QmlInterface::setPlaybackMode(int mode)
{
    m_repeatIndex = mode;

    if(mode == 0)
    {
        if(m_isShuffleEnabled)
        {}
        else
            playlist->setPlaybackMode(QMediaPlaylist::Sequential);
    }

    else if(mode == 1)
    {
        playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    }

    else
    {
        playlist->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

void QmlInterface::setPlayingState(bool state)
{
    if(state)
        m_isMusicPlaying = true;

    else
        m_isMusicPlaying = false;
}

void QmlInterface::setCurrentIndex(int index)
{
    playlist->setCurrentIndex(index);
}

int QmlInterface::getCurrentMusicIndex()
{
    return playlist->currentIndex();
}

void QmlInterface::onCurrentMusicIndexChanged()
{
    m_currentMusicIndex = playlist->currentIndex();

    emit musicIndexChanged();
}

void QmlInterface::onCurrentPlayerPositionChanged(int data)
{
    emit playerPositionChanged(data);
}

void QmlInterface::onCurrentMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    if(status == QMediaPlayer::LoadedMedia)
    {
        getMetaData(player);
    }
    if(player->duration() != 0)
    {
        emit musicDurationChanged(player->duration());
    }
}

void QmlInterface::getMetaData(QMediaPlayer *player)
{

}
