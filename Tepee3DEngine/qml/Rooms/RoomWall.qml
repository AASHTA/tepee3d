import QtQuick 2.0
import Qt3D 2.0
import Qt3D.Shapes 2.0

Quad
{
    id : main_wall

    property color wallIndicatorColor : "yellow"
    property string wallIndicatorTexture;
    property real  rotationAngle : 0;
    property vector3d rotationAxis : Qt.vector3d(0, 0, 0);
    property vector3d translationVector: Qt.vector3d(0, 0, 0);
    property real   panelRotationAngle : 0;
    property vector3d panelRotationAxis : Qt.vector3d(0, 0, 0);


    scale : 1
    position : Qt.vector3d(0, 0, 0)
    transform :
        [Rotation3D {angle : rotationAngle; axis: rotationAxis},
        Translation3D {translate : translationVector}]

    Behavior on z {NumberAnimation {duration : 30000}}
    Behavior on y {NumberAnimation {duration : 30000}}
    Behavior on z {NumberAnimation {duration : 30000}}

    function    showFaceIndicator()
    {
        if (!wallIndicatorAnimation.running)
            wallIndicatorAnimation.start()
    }

    SequentialAnimation
    {
        id : wallIndicatorAnimation
        SmoothedAnimation { id : scaleUpAnim; target: faceIndicator; property: "scale"; to : 0.5; velocity: 0.2; duration : -1; easing.type: Easing.InOutQuad }
        SmoothedAnimation { id : scaleDownAnim; target: faceIndicator; property: "scale"; to : 0.05; velocity: 1; duration : -1; easing.type: Easing.InOutQuad }
    }

    Quad
    {
        id : faceIndicator
        scale : 0.05
        enabled : (scale > 0.1)
        position : Qt.vector3d(0, faceIndicatorDistance, 0)
        inheritEvents : true
        transform : [Rotation3D {angle : panelRotationAngle; axis: panelRotationAxis}]
        effect : Effect {
           texture : wallIndicatorTexture
            blending : true
        }
    }
}