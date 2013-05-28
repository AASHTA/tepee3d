#ifndef TVSHOWMODEL_H
#define TVSHOWMODEL_H

#include <SubListedListItem.h>
#include <SubListedListModel.h>
#include "TVShowSeasonModel.h"

class TVShowModel : public Models::SubListedListItem
{
    Q_OBJECT
public:

    enum TVShowModelItemRoles
    {
        tvShowId = Qt::UserRole + 1,
        title,
        year,
        rating,
        playcount,
        episode,
        season, // UNUSED
        watchedepisodes, //UNUSED
        file,
        thumbnail
    };

    explicit TVShowModel(QObject *parent = 0, int tvShowId = -1);
    ~TVShowModel();

    int         id() const;
    QVariant    data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    Models::ListModel *submodel() const;

    int getTVShowId() const;
    int getYear() const;
    int getRating() const;
    int getSeason() const;
    int getEpisode() const;
    int getPlaycount() const;
    int getWatchedEpisodes() const;
    QString getFile() const;
    QString getTitle() const;
    QString getThumbnail() const;

    void setTvShowId(int tvShowId);
    void setYear(int year);
    void setRating(int rating);
    void setSeason(int season);
    void setEpisode(int episode);
    void setPlaycount(int playcount);
    void setWatchedEpisodes(int watchedEpisodes);
    void setFile(const QString &file);
    void setTitle(const QString &title);
    void setThumbnail(const QString &thumbnail);

private:
    Models::SubListedListModel*   seasonModels;
    int                             m_tvShowId;
    int                             m_year;
    int                             m_rating;
    int                             m_season;
    int                             m_episode;
    int                             m_playcount;
    int                             m_watchedEpisodes;
    QString                    m_file;
    QString                    m_title;
    QString                    m_thumbnail;

};

#endif // TVSHOWMODEL_H