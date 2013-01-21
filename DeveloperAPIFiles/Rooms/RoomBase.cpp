#include "RoomBase.h"
// DEBUG
#include <QDebug>

int Room::RoomBase::nextId = 0;

Room::RoomBase::RoomBase() : QQuickItem()
{
    this->roomId = Room::RoomBase::nextId++;
    this->roomProperties = new Room::RoomProperties(this);
}

Room::RoomBase::~RoomBase()
{

}

int         Room::RoomBase::getRoomId() const
{
    return this->roomId;
}

Room::RoomBase*   Room::RoomBase::getRoomBase()
{
    return this;
}

double            Room::RoomBase::getRoomVolume() const
{
    QVector3D scale = this->getScale();

    return scale.x() * scale.y() * scale.z();
}

bool            Room::RoomBase::operator <(RoomBase *room) const
{
    return this->getRoomVolume() < room->getRoomVolume();
}

bool            Room::RoomBase::operator >(RoomBase *room) const
{
    return this->getRoomVolume() > room->getRoomVolume();
}

QString     Room::RoomBase::getRoomName() const
{
    return this->roomProperties->getRoomName();
}

QString     Room::RoomBase::getRoomQmlFile() const
{
    return this->roomQmlFile;
}

QVector3D   Room::RoomBase::getPosition() const
{
    return this->roomProperties->getPosition();
}

QVector3D   Room::RoomBase::getScale() const
{
    return this->roomProperties->getScale();
}

ListModel*  Room::RoomBase::getRoomPluginsModel()   const
{
    return this->roomProperties->getRoomPluginsModel();
}

void        Room::RoomBase::setScale(const QVector3D &scale)
{
    this->roomProperties->setScale(scale);
}

void        Room::RoomBase::setRoomName(const QString &name)
{
    this->roomProperties->setRoomName(name);
}

void        Room::RoomBase::setPosition(const QVector3D &position)
{
    this->roomProperties->setPosition(position);
}

void        Room::RoomBase::setRoomQmlFile(const QString &file)
{
    this->roomQmlFile = file;
}

void        Room::RoomBase::addWidgetToRoom(Plugins::PluginBase *widget)
{
    QObject::connect(this, SIGNAL(roomEntered()), widget, SIGNAL(roomEntered()));
    QObject::connect(this, SIGNAL(roomLeft()), widget, SIGNAL(roomLeft()));
    QObject::connect(widget, SIGNAL(askForFocusState(Plugins::PluginEnums::PluginState,QObject*)),
                     this, SLOT(focusStateChangeRequest(Plugins::PluginEnums::PluginState, QObject*)));
    this->roomProperties->getRoomPluginsModel()->appendRow(new Plugins::PluginModelItem(widget));
}

void        Room::RoomBase::removeWidgetFromRoom(Plugins::PluginBase *widget)
{
    QObject::disconnect(this, SIGNAL(roomEntered()), widget, SIGNAL(roomEntered()));
    QObject::disconnect(this, SIGNAL(roomLeft()), widget, SIGNAL(roomLeft()));
    QObject::disconnect(widget, SIGNAL(askForFocusState(Plugins::PluginEnums::PluginState,QObject*)),
                     this, SLOT(focusStateChangeRequest(Plugins::PluginEnums::PluginState, QObject*)));
}

void        Room::RoomBase::updateRoom()
{
    // FOR LOGICAL UPDATE ONLY HAPPENS EVERY HALF SECONDS
    // IF YOU NEED TO UPDATE THE VIEW, USE A TIMER IN YOUR PLUGIN WITH A 50MS DURATION
    qDebug() << "Room is updated -> but you should should have implemented this method in the room subclass";
}

Room::RoomProperties*    Room::RoomBase::getRoomProperties() const
{
    return this->roomProperties;
}

Plugins::PluginBase*    Room::RoomBase::getPluginFromRoom(int pluginId) const
{
    Plugins::PluginModelItem* pluginItem = NULL;

    if ((pluginItem = (Plugins::PluginModelItem *)this->roomProperties->getRoomPluginsModel()->find(pluginId)) != NULL)
        return pluginItem->getPlugin();
    return NULL;
}

void        Room::RoomBase::enterRoom()
{
    emit (roomEntered());
}

void        Room::RoomBase::leaveRoom()
{
    emit (roomLeft());
}

void        Room::RoomBase::focusStateChangeRequest(Plugins::PluginEnums::PluginState requestedState, QObject* sender)
{
    Plugins::PluginBase*   plugin = NULL;
    bool                   requestAccepted = true;

    foreach (ListItem* pluginItem, this->roomProperties->getRoomPluginsModel()->toList())
    {
        plugin = ((Plugins::PluginModelItem*)(pluginItem))->getPlugin();
        if (plugin->getFocusState() != Plugins::PluginEnums::pluginIdleState)
        {
            requestAccepted = false;
            break;
        }
    }
    if (requestAccepted)
        ((Plugins::PluginBase*)(sender))->setFocusState(requestedState);
}
