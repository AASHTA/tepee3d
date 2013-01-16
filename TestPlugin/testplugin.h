#ifndef PLUGIN_H
#define PLUGIN_H

#include <QObject>
#include <QtPlugin>
#include "PluginBase.h"
#include "DatabaseServiceUserInterface.h"
#include "WebServiceUserInterface.h"

class TestPlugin : public Plugins::PluginBase          // MANDATORY FOR PLUGIN DEVELOPMENT
{
    Q_OBJECT                        // NECESSARY FOR QOBJECT INHERITANCE
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.testplugin")

signals :
    void toto(QString);

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
public slots:

};

#endif // PLUGIN_H
