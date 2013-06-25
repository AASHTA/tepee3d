#ifndef PLAYERMANAGER_H
#define PLAYERMANAGER_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QList>
#include <SubListedListModel.h>
#include "IWebRequestDispatcher.h"
#include "PlayableItemModel.h"
#include "MovieModel.h"
#include "TVShowEpisodeModel.h"
#include "SongModel.h"
#include "PlaylistModelItem.h"

#define MAJOR_ID_REQUEST_PLAYER 2
#define GENERIC_CALLBACK 0
#define GET_ACTIVE_PLAYERS 1
#define GET_PLAYED_ITEM 2
#define GET_PLAYER_STATE 3
#define GET_PLAYLISTS 4
#define GET_PLAYLIST_ITEMS 5

class PlayerManager : public QObject, public IWebRequestDispatcher
{
    Q_OBJECT
public:
    PlayerManager(QObject *parent = 0);

    void                    getActivesPlayers();
    void                    playFile(const QString &file);

    void                    pause_resumeCurrentPlayer();
    void                    playNext();
    void                    playPrevious();
    void                    stopCurrentPlayer();
    void                    seekCurrentPlayer(int advance);
    void                    getCurrentlyPlayedItem();
    void                    getCurrentPlayerState();


    bool                    getIsPlaying() const;
    double                  getPlayerAdvance() const;

    int                     getMajorIDRequestHandled() const;
    void                    receiveResultFromHttpRequest(QNetworkReply *reply, int id, void *data);



    void                    addToPlayList(const QString &file);
    void                    reloadPlaylists();
    void                    addPlaylist();
    void                    removePlaylist();


    Models::ListModel*      getPlaylistsModel() const;
    Models::ListModel*      getCurrentlyPlayedItemModel() const;


private:
    QHash<int, void (PlayerManager::*)(QNetworkReply *reply, void *data)>   webCallBacks;
    QList<void (PlayerManager::*)()>    playerActionQueue;
    Models::ListModel                   *currentlyPlayerItems;
    Models::SubListedListModel          *playlistsModels;

    int                                 currentActivePlayer;
    bool                                isPlayging;
    double                              playerAdvance;

    void                    getPlaylistItems(PlaylistModelItem *playlist);

    void                    genericCallBack(QNetworkReply *reply, void *data);
    void                    getActivesPlayersCallBack(QNetworkReply *reply, void *data);
    void                    getCurrentlyPlayedItemCallBack(QNetworkReply *reply, void *data);
    void                    getCurrentPlayerStateCallBack(QNetworkReply *reply, void *data);
    void                    getPlaylistsCallBack(QNetworkReply *reply, void *data);
    void                    getPlaylistItemsCallBack(QNetworkReply *reply, void *data);

    PlayableItemModel       *playableItemModelFromType(QString type);

signals:
    void                    performJsonRPCRequest(const QJsonObject &request, int requestId, void *data = NULL);
    void                    playingChanged();
    void                    playerAdvanceChanged();
};

#endif // PLAYERMANAGER_H
