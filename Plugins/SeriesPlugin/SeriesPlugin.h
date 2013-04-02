#ifndef SERIESPLUGIN_H
#define SERIESPLUGIN_H

#include <QObject>
#include <QtGui>
#include "QtQml"
#include <QQuickView>
#include <QQuickItem>
#include <QHash>
#include <PluginBase.h>
#include <DatabaseServiceUserInterface.h>
#include <WebServiceUserInterface.h>
#include <SubListedListModel.h>
#include <QJsonDocument>

#include "SerieSubListedItem.h"

#define PLUGIN_ID 10
#define SEARCH_SHOW_REQUEST 0
#define SEARCH_EPISODE_REQUEST 1
#define GET_SHOW_SUMMARY 2
#define UPDATE_SHOW_SUMMARY 3

#define RETRIEVE_SHOWS 0
#define RETRIEVE_SEASONS_FOR_SHOW 1
#define RETRIEVE_EPISODES_FOR_SHOW_SEASON 2
#define CHECK_IF_DATABASE_FORMAT_EXISTS 3
#define GENERIC_REQUEST 4

#define DATABASE_NAME "SeriesPlugin.sql"
#define TRAKT_API_KEY "9a67e6b3bc1cbd1d92fdc56a03b51267"

class SeriesPlugin  : public Plugins::PluginBase
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.SeriesPlugin")

public:
    SeriesPlugin();
    int                         getPluginId();
    void                        initPlugin();
    Q_INVOKABLE QString         getPluginName();
    QString                     getPluginDescription();
    PluginBase*                 getPluginBase();
    PluginBase*                 createNewInstance();
    QString                     getRoomPluginQmlFile() const;
    QString                     getMenuPluginQmlFile() const;


    // FOCUS STATE HANDLERS
    void                onIdleFocusState();
    void                onSelectedFocusState();
    void                onFocusedFocusState();

    // DatabaseServiceUserInterface
    void                        receiveResultFromSQLQuery(QList<QSqlRecord> result, int id, void *data);
    // WebServiceUserInterface
    void                        receiveResultFromHttpRequest(QNetworkReply * reply,int id, void *data);

    Q_INVOKABLE                 QObject* getFollowedSeriesModel() const;
    Q_INVOKABLE                 QObject* getSeasonsModelFromSerieId(int serieId) const;
    Q_INVOKABLE                 QObject* getEpisodesFromSeasonAndShowId(int serieId, int seasonId) const;
    Q_INVOKABLE                 QObject* getSearchSeriesModel() const;
    Q_INVOKABLE                 void     updateFollowedShows();
    Q_INVOKABLE                 void     searchForShow(QString showName);
    Q_INVOKABLE                 void     addShowToFollow(QString slug);
    Q_INVOKABLE                 void     searchForEpisode(QString episodeName);
    Q_INVOKABLE                 void     removeShowFromSearchResult(int showId);
    Q_INVOKABLE                 void     removeShowFromFollowedModel(int showId);

private:
    Models::SubListedListModel* followedSeriesModel;
    Models::SubListedListModel* searchSeriesModel;

    QHash<int, void (SeriesPlugin::*)(QNetworkReply*, void*)> webServicesCallBacks;
    QHash<int, void (SeriesPlugin::*)(QList<QSqlRecord>, void*)> databaseCallBacks;

    void                        updateShowSummary(SerieSubListedItem *show);
    SerieSubListedItem *        parseShow(const QJsonObject& showObj);
    SeasonSubListedItem*        parseShowSeason(const QJsonObject& seasonObj);
    EpisodeListItem    *        parseShowEpisode(const QJsonObject& episodeObj);

    // WEBSERVICES CALLBACK
    void                        searchForShowCallBack(QNetworkReply *reply, void *data);
    void                        getShowSummaryCallBack(QNetworkReply *reply, void *data);
    void                        searchForEpisodeCallBack(QNetworkReply *reply, void *data);
    void                        updateShowSummaryCallBack(QNetworkReply *reply, void *data);

    // DATABASE
    void                        addShowToDatabase(SerieSubListedItem *show);
    void                        addSeasonToDatabase(SeasonSubListedItem *season, const QString &showSlug);
    void                        addEpisodeToDatabase(EpisodeListItem *episode, const QString &showSlug, int season);

    void                        updateShowInDatabase(SerieSubListedItem *show);
    void                        updateSeasonInDatabase(SeasonSubListedItem *season, const QString &showSlug);
    void                        updateEpisodeInDatabase(EpisodeListItem *episode, const QString &showSlug, int season);

    void                        removeShowFromDatabase(const QString &showSlug);

    void                        retrieveShowsFromDababase();
    void                        retrieveShowSeasonsFromDatabase(int showDbId, SerieSubListedItem *show);
    void                        retrieveShowEpisodesFromDatabase(int showDbId, int seasonDbId, SeasonSubListedItem* season);

    // DATABASE CALLBACK
    void                        retrieveShowsFromDatabaseCallBack(QList<QSqlRecord> result, void *data);
    void                        retrieveSeasonsForShowDatabaseCallBack(QList<QSqlRecord> result, void *data);
    void                        retrieveEpisodesForShowSeasonDatabaseCallBack(QList<QSqlRecord> result, void *data);
    void                        checkIfDatabaseSchemaExists(QList<QSqlRecord> result, void *data);
    void                        genericDatabaseCallBack(QList<QSqlRecord> result, void *data);
};

#endif // SERIESPLUGIN_H
