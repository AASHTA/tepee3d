#ifndef PLUGIN_H
#define PLUGIN_H

#include <QtPlugin>
#include <QDebug>
#include <QQuickItem>
#include <PluginBase.h>

#define PLUGIN_VERSION "1.0.0"

class HarlemShake : public Plugins::PluginBase          // MANDATORY FOR PLUGIN DEVELOPMENT
{
    Q_OBJECT                        // NECESSARY FOR QOBJECT INHERITANCE
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.HarlemShake")

private:
    QQmlContext *context;

protected:
    void                onIdleFocusState();
    void                onSelectedFocusState();
    void                onFocusedFocusState();

public:
    HarlemShake();
    int                     getPluginId() const;
    void                    initPlugin();
    void                    clearPluginBeforeRemoval();
    Q_INVOKABLE QString     getPluginName() const;
    Q_INVOKABLE QString     getPluginDescription() const;
    Q_INVOKABLE QString     getPluginVersion() const;
    PluginBase*             getPluginBase();
    PluginBase*             createNewInstance();
    QString                 getRoomPluginQmlFile() const;
    QString                 getMenuPluginQmlFile() const;
    // DatabaseServiceUserInterface
    void                    receiveResultFromSQLQuery(QList<QSqlRecord> result, int id, void *data);
    // WebServiceUserInterface
    void                    receiveResultFromHttpRequest(QNetworkReply * reply, int requestId, void *data);
private slots :

    void                    onFocusStateChanged();


};

#endif // PLUGIN_H
