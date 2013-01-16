// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import Qt3D 2.0
import Qt3D.Shapes 2.0

//Item3D
//{
//    scale:0.2
//    position:Qt.vector3d(0,1.5,6)
//    mesh : Mesh {source:"Resources/Models/dog.3ds"}
//}

Item3D
{
    property real zRot : 0;
    property real yRot : 0;
    property color col : "red"


//    Carousel
//    {
//        id : carousel
//        scale : 5
//        radius : 3
//    }

    Cube
    {
        id : cube_plugin

        scale : 5
        position : Qt.vector3d(0, 0, 0)
        effect: Effect {color :col}
//        transform : [Rotation3D {angle : zRot; axis : Qt.vector3d(0, 0, 1)},
//            Rotation3D {angle : yRot; axis : Qt.vector3d(0, 1, 0)}]





        //    Timer
        //    {
        //        running : true
        //        repeat: true
        //        interval: 25
        //        onTriggered:
        //        {
        //            zRot += 1
        //            yRot += 1
        //        }
        //    }


        onHoverEnter :
        {
            col = "orange"
            console.log("Hover");
        }

        onHoverLeave :
        {
            col = "red"
        }

        onPressed :
        {
            var oldPos = position;
            console.log("pressed");
        }

        //    onClicked :
        //    {
        //        console.log("Plugin picked");
        //    }

    }
}
