import QtQuick 2.1

Item
{
    id : item_plugin_del
    property string pluginName : ""
    property bool downloaded : false;
    property bool downloading : false;

    anchors.horizontalCenter: parent.horizontalCenter
    scale : plugin_delegate_mouse_area.pressed ? 0.9 : 1.0
    Behavior on scale {SmoothedAnimation {velocity : 1; duration : -1}}

    MouseArea
    {
        id : plugin_delegate_mouse_area
        anchors.fill : parent
        onClicked :
        {
            room_plugins_list_view.currentIndex = index;
            console.log("Plugin ID " + model.pluginId)
            roomManager.addNewPluginToCurrentRoom(model.pluginId)
            menuRightRec.add_plugins = !menuRightRec.add_plugins
        }
    }

    BorderImage
    {
        id: delRect
        source: (room_plugins_list_view.currentIndex === index) ?  "../Resources/Pictures/delegate_selected.png" : "../Resources/Pictures/delegate.png"
        anchors.fill: parent
        Behavior on rotation {SpringAnimation {spring: 30; damping: 0.3; mass: 1.0}}
    }

    Text
    {
        id: plugin_title
        text: pluginName
        anchors.centerIn: delRect
        color :  "white"
    }
}
