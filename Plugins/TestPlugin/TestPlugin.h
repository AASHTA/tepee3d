#ifndef PLUGIN_H
#define PLUGIN_H

#include <QtPlugin>
#include <QDebug>
#include <QQuickItem>
#include <PluginBase.h>

#define  ASSIGNCOLOR 2
#define  PLUGIN_VERSION "1.0.0"

class TestPlugin : public Plugins::PluginBase          // MANDATORY FOR PLUGIN DEVELOPMENT
{
    Q_OBJECT                        // NECESSARY FOR QOBJECT INHERITANCE
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.testplugin")

private:
    QString colorSelect;
    QQmlContext *context;

protected:
    void                onIdleFocusState();
    void                onSelectedFocusState();
    void                onFocusedFocusState();

public:
    TestPlugin();
    int                     getPluginId() const;
    void                    initPlugin();
    void                    clearPluginBeforeRemoval();
    Q_INVOKABLE  QString    getPluginName() const;
    Q_INVOKABLE  QString    getPluginDescription() const;
    Q_INVOKABLE  QString    getPluginVersion() const;
    Q_INVOKABLE  QString    getPluginRepoName() const;
    PluginBase*             createNewInstance();

    QString                 getRoomPluginQmlFile() const;
    QString                 getMenuPluginQmlFile() const;
    // DatabaseServiceUserInterface
    void                    receiveResultFromSQLQuery(QList<QSqlRecord> result, int id, QPointer<QObject>);
    // WebServiceUserInterface
    void                    receiveResultFromHttpRequest(QNetworkReply * reply, int requestId, QPointer<QObject>);
    void setColor(QString color);
    Q_INVOKABLE void selectColor(QString color);
    Q_INVOKABLE QString getColor();

private slots :

    void                    onFocusStateChanged();


};

#endif // PLUGIN_H
