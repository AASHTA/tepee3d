import QtQuick 2.1
import Qt3D 2.0
import Plugins 1.0
import "../js/CameraManagement.js" as CameraManagement
import "../js/Walls.js" as Walls

Item3D
{
    id : plugin_base

    property int pluginId : -1
    property int pluginRoomId :-1
    property string roomQmlFile : ""
    property string menuQmlFile : ""
    property string pluginName : ""
    property string pluginRepoName : ""
    property vector3d pluginPosition : Qt.vector3d(0, 0, 0)

    // TO ASK FOR A GIVEN FOCUS STATE CALL
    // plugin_base.askForFocusState(State)
    // IF CHANGE ACCEPTED, corresponding handler will be called

    ///////////////// UTILITY FUNCTIONS THE PLUGIN CAN CALL
    function askForRoomFocusState()            {plugin_properties.askForFocusState(0)}
    function askForRoomSelectedFocusState()    {plugin_properties.askForFocusState(1)}
    function askForFocusedFocusState()         {plugin_properties.askForFocusState(2)}
    function getFocusState()                   {return plugin_properties.focusState}
    function moveCamera(eye, center, up)       {CameraManagement.moveCamera(camera, eye, center, up)}
    function getCameraOrientation()            {return camera.getCameraOrientation()}
    // RETURN DEEP COPY OF ROOM VARIABLES SO THEY CANNOT MODIFY THE ROOM DIRECTLY
    function getRoomPosition()                 {return room_item.getRoomPosition()}
    function getRoomScale()                    {return room_item.getRoomScale()}
    // REGISTER PLUGIN SO THAT IT CAN RECEIVE MOUSE MOVE EVENTS
//    function setEditMode(obj)                  {mainWindow.mouseObjectGrabber = obj}
    // TO DISPLAY NOTIFICATION MESSAGE AND POP UP
    function postNotification(message, type)   {mainWindow.postNotification(message, type)}
    function showPopUp(popupUrl)               {mainWindow.showPopUp(url)}

    // RETURNS THE DISTANCE BETWEEN TWO POINTS
    function computeDistance(pointA, pointB)
    {
        return Math.sqrt(Math.pow((pointA.x - pointB.x), 2) +
                         Math.pow((pointA.y - pointB.y), 2) +
                         Math.pow((pointA.z - pointB.z), 2))
    }

    // RETURNS ROTATION OF A POINT AROUND AN ORIGIN POINT AND AN ANGLE
    function computeRotation(originPoint, rotPoint, rotAxis, rotAngle)
    {
        var radAngle = Math.PI * rotAngle / 180;
        var translatedOrigin = Qt.vector3d(rotPoint.x -originPoint.x,
                                           rotPoint.y -originPoint.y,
                                           rotPoint.z -originPoint.z);
        var rotatedPoint;
        if (rotAxis.x !== 0)
            rotatedPoint = Walls.xAxisRotation(translatedOrigin, rotAxis.x * radAngle)
        else if (rotAxis.y !== 0)
            rotatedPoint = Walls.yAxisRotation(translatedOrigin, rotAxis.y * radAngle)
        else
            rotatedPoint = Walls.zAxisRotation(translatedOrigin, rotAxis.z * radAngle);
        rotatedPoint.x += originPoint.x;
        rotatedPoint.y += originPoint.y;
        rotatedPoint.z += originPoint.z;
        return rotatedPoint;
    }

    PluginProperties
    {
        id : plugin_properties
        pluginId : plugin_base.pluginId
        pluginRoomId: plugin_base.pluginRoomId

        onPluginIdChanged :        {}
        onPluginRoomIdChanged: {console.log("RoomId " + pluginRoomId)}

        // WHEN CREATED A PLUGIN IS NOT LOADED BEFORE IT HAS BEEN INITIALIZED WITH A pluginId AND A roomId
        // ONCE THAT IS DONE, THE FOCUS STATE IS SET TO IDLE
        // IF THE LOADER HAS NOT LOADED ANY ELEMENT YET THEN IT LOADS THE PLUGINS
        // OTHERWISE IT TRANSMITS THE SIGNAL TO THE PLUGIN ITEM

        onFocusStateChanged:
        {
            console.log("v State " + newFocusStateValue + "  "  + focusState);
            // IF THE PLUGIN HAS NEVER BEEN LOADED WE LOAD IT
            if (newFocusStateValue === 0 && !plugin_loader.item)
                plugin_loader.source =  "../../plugins_qml/" + pluginRepoName + "/" + roomQmlFile;
            if (!plugin_loader.item)
                return ;
            // CALL THE FOCUS HANDLER MATCHING THE NEW FOCUS STATE
            if (newFocusStateValue === 2)
            {
                // TELL THE PARENT ROOM THERE IS A PLUGIN FOCUSED
                room_item.isAPluginFocused = true;
                console.log("MENU IS >>>> " + menuQmlFile)
                mainWindow.pluginMenuSource = "../../plugins_qml/" + pluginRepoName + "/" + menuQmlFile;
                plugin_loader.item.switchToFocusedView();
            }
            else
            {
                // MENU IS UNLOADED WHEN NOT IN FOCUSED MODE
                mainWindow.pluginMenuSource = "";
                // TELLS THE ROOM THE PLUGIN IS NO MORE FOCUSED
                if (previousFocusState === 2)
                    room_item.isAPluginFocused = false;
                // CALL MATCHING FOCUS HANDLER IN THE PLUGIN
                if (newFocusStateValue === 0)
                    plugin_loader.item.switchToIdleFocusView();
                else
                    plugin_loader.item.switchToSelectedFocusView();
            }
        }

        onRoomEntered :
        {
            console.log("Room Entered ???");
            if (plugin_loader.item)
                plugin_loader.item.roomEntered();
        }

        onRoomLeft :
        {
            if (plugin_loader.item)
                plugin_loader.item.roomLeft();
            console.log("Room Left ????");
        }
    }

    Item3D
    {
        position : plugin_base.pluginPosition
        Loader    {id : plugin_loader}
    }
}
