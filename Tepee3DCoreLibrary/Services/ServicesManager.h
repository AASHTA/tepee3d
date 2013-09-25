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

#ifndef SERVICESMANAGER_H
#define SERVICESMANAGER_H

#include <QObject>
#include <QLibrary>
#include <QDir>
#include <QCoreApplication>
#include <QPluginLoader>
#include <QSqlRecord>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QHttpMultiPart>
#include <Utils.h>
#include "ServiceInterface.h"
#include "DatabaseServiceUserInterface.h"
#include "WebServiceUserInterface.h"
#include "FileDownloaderServiceUserInterface.h"
#include "QmlContentExposerInterface.h"
#include "PlatformFactory.h"

// THIS CLASS WILL BE THE INTERMEDIARY BETWEEN ALL SERVICES (APART FROM STATIC FUNCTIONS)
// IT WILL CONNECT ALL THE NECESSARY SIGNAL
// LOAD THE SHARED LIBRARIES CONTAINING THE PLUGINS AND SO ON
// ADDITIONALLY THIS CLASS WILL CONTAIN Q_INVOKABLE METHODS AND BE EXPOSED TO THE QML ENGINE SO THAT
// QML CAN INVOKE METHODS DIRECTLY IF NEEDED

#define CHECK_SERVICES_VERSION 0
#define DOWNLOAD_SERVICE 1

namespace Services
{

class ServicesManager : public QObject,
                                          public View::QmlContentExposerInterface,
                                          public Services::WebServiceUserInterface

{
    Q_OBJECT
    Q_INTERFACES(View::QmlContentExposerInterface)
    Q_INTERFACES(Services::WebServiceUserInterface)

public:
    ~ServicesManager();
    void    exposeContentToQml(QQmlContext *context);
    static  ServicesManager*        getInstance(QObject *parent = 0);
    Q_INVOKABLE static  void        connectObjectToServices(QObject *serviceUser);
    Q_INVOKABLE static  void        disconnectObjectFromServices(QObject *serviceUser);
    void                            loadServicesLibraries();

    void                            receiveResultFromHttpRequest(QNetworkReply *reply, int requestId, QPointer<QObject> data);
    void                            checkForServicesUpdates();
    void                            downloadServiceFromServer(int serviceId);

private:
    static ServicesManager          *instance;
    ServicesManager(QObject *parent = 0);
    QList<ServiceInterface*>        services;
    QHash<int, void (ServicesManager::*)(QNetworkReply *, QPointer<QObject>)>      webServicesCallBacks;

    void                            checkForServicesUpdatesCallBack(QNetworkReply *reply, QPointer<QObject>data);
    void                            dowloadServiceFromServerCallBack(QNetworkReply *reply, QPointer<QObject>data);
    void                            preloadThirdPartyLibraries();


public slots :
    void                            connectObjectToServicesSlot(QObject *serviceUser);
    void                            disconnectObjectFromServicesSlot(QObject *serviceUser);
    void                            libraryInitialized();

signals :
    void                            librariesInitialized();
    void executeHttpRequest(const QNetworkRequest&,
                            Services::WebServiceUserInterface::WebServiceRequestType,
                            QHttpMultiPart*,
                            QPointer<QObject> sender,
                            int requestId,
                            QPointer<QObject> data = QPointer<QObject>());
};

}
#endif // SERVICESMANAGER_H
