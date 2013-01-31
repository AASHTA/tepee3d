#ifndef PLUGIN_H
#define PLUGIN_H

#include <QObject>
#include <QtPlugin>
#include <iostream>
#include <QObject>
#include <QDebug>
#include <QtGui>
#include "QtQml"
#include <QQuickView>
#include <QQuickItem>
#include "PluginBase.h"
#include "DatabaseServiceUserInterface.h"
#include "WebServiceUserInterface.h"
#include "widgetmodel.h"


class TestPlugin : public Plugins::PluginBase          // MANDATORY FOR PLUGIN DEVELOPMENT
{
    Q_OBJECT                        // NECESSARY FOR QOBJECT INHERITANCE
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.testplugin")

public:
    TestPlugin();
    int                     getPluginId();
    void                    initPlugin();
    QString                 getPluginName();
    QString                 getPluginDescription();
    PluginBase*             getPluginBase();
    PluginBase*             createNewInstance();

    QString                 getRoomPluginQmlFile() const;
    QString                 getFocusedPluginQmlFile() const;
    // DatabaseServiceUserInterface
    void                    receiveResultFromSQLQuery(const QList<QSqlRecord> &result);
    // WebServiceUserInterface
    void                    receiveResultFromHttpRequest(QNetworkReply * reply);

signals :
    void qmlSignal();
public slots:
    void cppSlot();
};

#endif // PLUGIN_H
