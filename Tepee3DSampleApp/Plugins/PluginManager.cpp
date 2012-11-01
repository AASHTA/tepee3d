#include "PluginManager.h"
// DEBUG
#include <QDebug>


ListModel* Plugins::PluginManager::availablePluginsModel = NULL;

Plugins::PluginManager::PluginManager(QObject *parent) : QObject(parent)
{
    this->loadLocalPlugins();
    // THE SIGNAL MAPPER WILL BE USED TO MANAGE CONNECTIONS BETWEEN
    // PLUGINS AND THE SERVICE MANAGER, AUTOMATICALLY PASSING THE PLUGIN
    // INSTANCE TO SERVICE SIGNALS SO THAT THE SERVICE AUTOMATICALLY RESPONDS TO THE PLUGIN
    // WHO MADE THE REQUEST
    this->signalMapper = new QSignalMapper(this);
}

Plugins::PluginManager::~PluginManager()
{
}

void Plugins::PluginManager::loadLocalPlugins()
{
    PluginLoader::loadWidgetPlugins();
    if (Plugins::PluginManager::availablePluginsModel == NULL)
        Plugins::PluginManager::availablePluginsModel = new ListModel(new Plugins::PluginModelItem(NULL, NULL));
    else
        Plugins::PluginManager::availablePluginsModel->clear();
    foreach (Plugins::PluginBase*  plugin, PluginLoader::getWidgetPlugins())
    {
        Plugins::PluginManager::availablePluginsModel->appendRow(new Plugins::PluginModelItem(plugin, this));
        // DO PLUGIN CONNECTION TO SIGNAL MAPPER FOR SERVICES HERE
    }
}

void    Plugins::PluginManager::receiveResultFromSQLQuery(const QList<QSqlRecord> &result)
{
    qDebug() << "PluginManager Received Result";
}

Plugins::PluginBase* Plugins::PluginManager::getNewInstanceOfPlugin(PluginBase *plugin)
{
    if (plugin == NULL)
        return NULL;
    return plugin->createNewInstance();
}

Plugins::PluginBase* Plugins::PluginManager::getNewInstanceOfPlugin(int pluginModelItemId)
{
    Plugins::PluginModelItem*   pluginModelItem = NULL;
    Plugins::PluginBase *pluginBase = NULL;
    if ((pluginModelItem = (Plugins::PluginModelItem*)Plugins::PluginManager::availablePluginsModel->find(pluginModelItemId)) != NULL)
        pluginBase = pluginModelItem->getPlugin();

    return Plugins::PluginManager::getNewInstanceOfPlugin(pluginBase);
}

void    Plugins::PluginManager::exposeContentToQml(QQmlContext *context)
{
    context->setContextProperty("availablePluginsModel", this->availablePluginsModel);
}
