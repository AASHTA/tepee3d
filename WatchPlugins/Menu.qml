import QtQuick 2.0

// MUST CONTAIN ONLY QtQuick 2 elements, no 3D

Item
{
    anchors.fill: parent

    Rectangle
    {
        color : "red"
        anchors.fill: parent
        Text {
            text : "Menu Setting For plugin" + apc.getPluginName()
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

}
