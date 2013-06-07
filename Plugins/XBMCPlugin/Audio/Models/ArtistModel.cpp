/****************************************************************************
**
** Copyright (C) Paul Lemire, Tepee3DTeam and/or its subsidiary(-ies).
** Contact: paul.lemire@epitech.eu
** Contact: tepee3d_2014@labeip.epitech.eu
**
** This file is part of the Tepee3D project
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
****************************************************************************/

#include "ArtistModel.h"

ArtistModel::ArtistModel(QObject *parent, int artistId) : Models::SubListedListItem(parent)
{
    this->m_artistId = artistId;
    this->songModel = new Models::ListModel(NULL);
}

QString ArtistModel::getArtistName() const
{
    return this->m_artistName;
}

void ArtistModel::setArtistName(const QString &artistName)
{
    this->m_artistName = artistName;
}

ArtistModel::~ArtistModel()
{
    delete this->songModel;
}

int ArtistModel::id() const
{
    return this->m_artistId;
}

QHash<int, QByteArray> ArtistModel::roleNames() const
{
    QHash<int, QByteArray>  roleNames;

    roleNames[artistId] = "artistId";
    roleNames[artistName] = "artistName";
    roleNames[birthDate] = "birthDate";
    roleNames[thumbnail] = "thumbnail";
    roleNames[genre] = "genre";
    roleNames[mood] = "mood";
    return roleNames;
}

QVariant ArtistModel::data(int role) const
{
    switch (role)
    {
    case artistId:
        return this->id();
    case artistName:
        return this->getArtistName();
    case birthDate:
        return this->getBirthDate();
    case thumbnail:
        return this->getThumbnail();
    case genre:
        return this->getGenre();
    case mood:
        return this->getMood();
    default:
        return QVariant();
    }
}

Models::ListModel *ArtistModel::submodel() const
{
    return this->songModel;
}

QString ArtistModel::getMood() const
{
    return m_mood;
}

void ArtistModel::setMood(const QString &mood)
{
    m_mood = mood;
}

QString ArtistModel::getThumbnail() const
{
    return this->m_thumbnail;
}

void ArtistModel::setThumbnail(const QString &thumbnail)
{
    this->m_thumbnail = QUrl::toPercentEncoding(thumbnail);
}

QString ArtistModel::getGenre() const
{
    return this->m_genre;
}

void ArtistModel::setGenre(const QString &genre)
{
    this->m_genre = genre;
}

QString ArtistModel::getBirthDate() const
{
    return this->m_birthDate;
}

void ArtistModel::setBirthDate(const QString &birthDate)
{
    this->m_birthDate = birthDate;
}
