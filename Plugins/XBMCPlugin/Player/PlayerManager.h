#ifndef PLAYERMANAGER_H
#define PLAYERMANAGER_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QList>
#include <ListModel.h>
#include "IWebRequestDispatcher.h"
#include "PlayableItemModel.h"
#include "MovieModel.h"
#include "TVShowEpisodeModel.h"
#include "SongModel.h"

#define MAJOR_ID_REQUEST_PLAYER 2
#define GENERIC_CALLBACK 0
#define GET_ACTIVE_PLAYERS 1
#define GET_PLAYED_ITEM 2

class PlayerManager : public QObject, public IWebRequestDispatcher
{
    Q_OBJECT
public:
    PlayerManager(QObject *parent = 0);

    void                    getActivesPlayers();
    void                    playFile(const QString &file);
    void                    addToPlayList(const QString &file);

    void                    pause_resumeCurrentPlayer();
    void                    playNext();
    void                    playPrevious();
    void                    stopCurrentPlayer();
    void                    seekCurrentPlayer(int advance);
    void                    getCurrentlyPlayedItem();

    int                     getMajorIDRequestHandled() const;
    void                    receiveResultFromHttpRequest(QNetworkReply *reply, int id, void *data);

    Models::ListModel*      getCurrentlyPlayedItemModel() const;

private:
    QHash<int, void (PlayerManager::*)(QNetworkReply *reply, void *data)>   webCallBacks;
    QList<void (PlayerManager::*)()>    playerActionQueue;
    Models::ListModel                   *currentlyPlayerItems;
    int                                 currentActivePlayer;

    void                    genericCallBack(QNetworkReply *reply, void *data);
    void                    getActivesPlayersCallBack(QNetworkReply *reply, void *data);
    void                    getCurrentlyPlayerItemCallBack(QNetworkReply *reply, void *data);
    PlayableItemModel       *playableItemModelFromType(QString type);

signals:
    void                    performJsonRPCRequest(const QJsonObject &request, int requestId, void *data = NULL);
};

#endif // PLAYERMANAGER_H
