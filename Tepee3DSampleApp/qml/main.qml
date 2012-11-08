// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import Qt3D.Shapes 2.0
import Qt3D 2.0
import BufferedTextureSourcePlugin 1.0


Viewport
{
    id : mainWindow

    property color menu_background_color : "#0066ff";
    property color room_list_component_color : "#0099dd";
    property color room_list_selected_component_color : "#0066cc";
    property color plugin_list_component_color : "#0099dd";
    property color plugin_list_selected_component_color : "#0066cc";
    property real  menu_opacity_deployed : 1.0;



    width: 1024
    height: 768

    navigation : false

    picking : true      // TO ALLOW MOUSE EVENTS ON 3D ITEMS
    //blending : true     // ALLOW TRANSPARENCY
    //    showPicking : true  // FOR DEBUG PURPOSES ONLY
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

    lightModel : LightModel {
        //        model : "TwoSided"
        model : "OneSided"
        viewerPosition : "LocalViewer"
        //        viewerPosition : "ViewerAtInfinity"
        ambientSceneColor : "#ffffff"
    }

    light : Light {
        ambientColor : "white";
        diffuseColor : "white"
        specularColor : "white"
        position : Qt.vector3d(10, 10, 100)
        linearAttenuation : 0
    }



    camera: TepeeCamera {
        id : camera
    }

    Timer
    {
        id : camera_timer
        running : true
        interval : 40
        repeat : true
        onTriggered:
        {
            camera.angle += 0.05
            if (camera.angle >= 360)
                camera.angle -= 360;
            camera.xCam = 100 * Math.cos(camera.angle)
            camera.zCam = 100 * Math.sin(camera.angle)
        }
    }


    focus : true

    Keys.onLeftPressed:
    {

    }
    Keys.onRightPressed:
    {
    }
    Keys.onUpPressed:
    {
        camera.zCam += 1;
        //        camera.zCamCenter += 5
        console.log("Eye " + camera.eye.x + "," + camera.eye.y + "," + camera.eye.z + " Center " + camera.center.x + "," + camera.center.y + "," + camera.center.z);
    }
    Keys.onDownPressed:
    {
        camera.zCam -= 1;
    }

    Skybox
    {
        source : "sky15"
    }

    Room
    {
        id : room
        x : 150;
        y : 150.0;
        z : 150.0;

        transform : [ Scale3D { scale : Qt.vector3d(30, 20, 30)}]

        onClicked :
        {
            console.log("toto");
        }

        onPositionChanged :
        {
            console.log(position);
        }
    }

    Repeater
    {
        model : roomModel
        delegate : roomDelegate
    }

    Component                   // NOT WORKING YET -> Qt5 Bug should be resolved by release version
    {                           // https://bugreports.qt-project.org/browse/QTBUG-27444
        id : roomDelegate

        RoomLoader              // LOAD THE ROOM QML FILE SPECIFIED IN THE MODEL
        {                       // QT BUG NOT WORKING YET
            id : room_loader
            roomPosition : model.roomPosition
            roomScale : model.roomScale
            widgetsModel : null
//            source : "Room.qml"
        }
    }  

    MenuCenter
    {
        anchors.fill : parent
    }
}
