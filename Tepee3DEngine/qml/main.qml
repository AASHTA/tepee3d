// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import Qt3D 2.0
import Qt3D.Shapes 2.0
import BufferedTextureSourcePlugin 1.0

Viewport
{
    id : mainWindow

    property color menu_background_color : "#404040";
    property color room_list_component_color : "#0099dd";
    property color room_list_selected_component_color : "#0066cc";
    property color plugin_list_component_color : "#0099dd";
    property color plugin_list_selected_component_color : "#0066cc";
    property real  menu_opacity_deployed : 1.0;
    property real  menu_opacity_retracted : 0;
    property int   camera_movement_velocity : 250;
    property int   menuMinimumWidth : 40
    property int   currentRoomId : 0;
    property int   currentRoomFaceId : 0;

    property alias pluginMenuSource : menu_center.pluginMenuSource
    property variant mouseObjectGrabber : null

    signal roomChanged(int roomId);
    signal roomFaceIdChanged(int roomFaceId);

    Component.onCompleted:    {Room.initialize(camera, roomModel, currentRoomFacesModel); moveCameraToSkyView()}

    onCurrentRoomIdChanged:
    {
        console.log("Room Changed " + currentRoomId)
        roomManager.setCurrentRoom(currentRoomId);
        Room.moveToRoom(currentRoomId, currentRoomFacesModel)
        roomChanged(currentRoomId)
        currentRoomFaceId = 0;
    }

    onCurrentRoomFaceIdChanged:
    {
        console.log("ROOM FACE CHANGED >>>>>>>>>>>>" + currentRoomFaceId)
        Walls.moveCameraToWall(currentRoomFaceId)
        roomFaceIdChanged(currentRoomFaceId)
    } // NORTH FACE BY DEFAULT, USE FOR CULLING

    function    moveCameraToSkyView()    {Camera.moveCamera(camera, Qt.vector3d(0, 300 + (150 * Math.floor(roomModel.count/ 10)), -1), Qt.vector3d(0, 1, 1), Qt.vector3d(0, 0, 1))}
    function getcurrentIdRoom()
    {
        roomChanged(currentRoomId)
        return currentRoomId;
    }
    function moveCameraHomeRoom()
    {
        Walls.moveCameraToWall(0)
    }
    function inRoom()
    {
        if(currentRoomId <= 0)
            return false;
        else
            return true;
    }

    // FOR 16 / 9
    width: 1280
    height: 720

    //    width: 1680
    //    height: 1050
    // FOR 4 / 3
    //    width : 1024
    //    height : 728
    //    focus : true
    navigation : false
    picking : true     // TO ALLOW MOUSE EVENTS ON 3D ITEMS
    blending : true     // ALLOW TRANSPARENCY
    showPicking : false  // FOR DEBUG PURPOSES ONLY
    objectName : "viewport"

    //               y ^  _
    //                 |  /| z
    //                 | /
    //                 |/
    //      x <--------/---------
    //                /|
    //               / |
    //              /  |
    //

    ListModel    {id : currentRoomFacesModel} // STORES FACES INFORMATION ABOUT THE CURRENT ROOM

    function    onRoomSwitch()    {camera_movement_velocity = 200;currentRoomFaceId = 0;}
    function    onRoomFaceSwitch()    {camera_movement_velocity = 100;}

    lightModel : LightModel {
        //        model : "OneSided"
        //        viewerPosition : "LocalViewer"
        model : "TwoSided"
        viewerPosition : "ViewerAtInfinity"
        ambientSceneColor : "#ffffff"
    }

    light : Light {
        ambientColor : "white";
        diffuseColor : "white"
        specularColor : "white"
        position : Qt.vector3d(0, 0, 0)
        linearAttenuation : 0
    }

    camera: TepeeCamera     {id : camera}

    //    Keys.onLeftPressed:    {}
    //    Keys.onRightPressed:    {}
    //    Keys.onUpPressed:    {}
    //    Keys.onDownPressed:    {}

    Skybox    {source : "sky15"}

    RoomsContainer    {id : roomContainer}

    MenuCenter    {id : menu_center; anchors.fill : parent}

    //    BufferedTextureSource
    //    {
    //        sourceItem : menu_center
    //    }

    function    postNotification(message, type) {notification.sendMessage(message, type)}
    function    showPopUp(url) {notification.showPopUp(url)}

    NotificationManager    {id : notification}

    //        FpsCounter {}
}
