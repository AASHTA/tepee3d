#include "DummyProject.h"

DummyProject::DummyProject() : PluginBase()
{
    this->initPlugin();
}
// ALL the function should be implemented

int DummyProject::getPluginId()
{
    return 1;
}

void DummyProject::initPlugin()
{
    this->executeHttpGetRequest(QNetworkRequest(QUrl("http://127.0.0.1/RESTphp/index.php")),1);
}

void DummyProject::clearPluginBeforeRemoval()
{
}

QString DummyProject::getPluginName()
{
    return QString("DummyProject");
}

QString DummyProject::getPluginDescription()
{
    return QString("DummyProject.qml");
}

Plugins::PluginBase* DummyProject::getPluginBase()
{
    return this;
}

QString DummyProject::getRoomPluginQmlFile() const
{
    return QString("DummyProject.qml");
}

QString DummyProject::getMenuPluginQmlFile() const
{
    return QString("Menu.qml");
}

Plugins::PluginBase* DummyProject::createNewInstance()
{
    return new DummyProject();
}

void    DummyProject::receiveResultFromSQLQuery( QList<QSqlRecord> , int , void *)
{
}

void    DummyProject::receiveResultFromHttpRequest(QNetworkReply *reply, int , void *)
{
    qDebug() << reply->readAll();
}

