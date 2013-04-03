import QtQuick 2.0
import Qt3D 2.0
import Qt3D.Shapes 2.0
import QtQuick.Particles 2.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.0


Item3D
{
    id : hs_container

    property real zRot : 1;
    property real yRot : 0;
    property color col : "red";
    property int savedX;
    property int savedY;
    property real savedXPos;
    property real savedYPos;
    property vector3d savedCameraOrientation;
    property bool isFocused : false;
    property bool delayAnimHarlem : false;

    Audio
    {
        id: playMusic
        source: "HS.mp3"
        autoPlay: false
        volume : 0.15
    }

    position : Qt.vector3d(0, 0, 0)
    // HAS TO BE IMPLEMENTED
    function roomEntered()    {}
    // HAS TO BE IMPLEMENTED
    function roomLeft()    {}
    // HAS TO BE IMPLEMENTED
    function switchToIdleFocusView()    {plugin_base.moveCamera(); isFocused = false; playMusic.stop(); delayAnimHarlem = false}
    // HAS TO BE IMPLEMENTED
    function switchToSelectedFocusView()    {isFocused = false}
    // HAS TO BE IMPLEMENTED
    function switchToFocusedView()
    {
        var eyePos = plugin_base.getRoomPosition();
        eyePos.z += (-10)

        var widgetPos = plugin_base.getRoomPosition();
        widgetPos.x += hs_container.x
        widgetPos.y += hs_container.y
        widgetPos.z += hs_container.z
        plugin_base.moveCamera(eyePos, widgetPos);
        isFocused = true;

        playMusic.play();
        harlem_timer.start()
    }


    states : [
        State {
            name : "idle"
            PropertyChanges {target: hs_container;}
            when : plugin_base.getFocusState() === 0
        },
        State {
            name : "selected"
            PropertyChanges {target: hs_container;}
            when : plugin_base.getFocusState() === 1
        },
        State {
            name : "focused"
            PropertyChanges {target: hs_container;}
            when : plugin_base.getFocusState() === 2
        }
    ]
    Timer {
        id : harlem_timer
        interval: 18500
        repeat: false
        running: false
        onTriggered: {delayAnimHarlem = true;}
    }
    Timer
    {
        id : stop_timer
        repeat : false
        running:false
        onTriggered:
        {
            playMusic.stop();
            delayAnimHarlem = false;
        }
    }

    Item3D
    {
        id : buttons
        enabled : true
        Cube
        {
            id : cube_orange
            effect: Effect {id : effectorange;color: "orange"}
            scale : 1
            position : Qt.vector3d(-1, 1, -2)
            onClicked:{cube_plugin.effect.color = "orange";}
            transform: [
                Rotation3D {
                    id : xRT
                    angle: 0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, -1, 0)
                }
            ]
            SequentialAnimation {
                id : color_animation_orange
                running : delayAnimHarlem
                loops : Animation.Infinite
                PropertyAnimation {target:effectorange;properties: "color"; to: "green"; duration: 1000; }
                PropertyAnimation {target:effectorange; properties: "color"; to: "red"; duration: 1000; }
                PropertyAnimation {target:effectorange; properties: "color"; to: "orange"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_orange
                running : delayAnimHarlem
                loops : Animation.Infinite
                NumberAnimation{ target: cube_orange;property: "scale"; to: 0.50;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 100 }
                NumberAnimation {target: cube_orange;property: "scale";to: 1.5;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_orange; target: xRT; running: delayAnimHarlem; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }
        }

        Cube
        {
            id : cube_red
            effect: Effect {id : effectred;color: "red"}
            scale : 1
            position : Qt.vector3d(2, 1, 1)
            onClicked:{cube_plugin.effect.color = "red";}
            transform: [
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    id : zRT
                    angle: 0.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {

                    angle: 45.0
                    axis: Qt.vector3d(0, -1, 0)
                }
            ]
            SequentialAnimation {
                id : color_animation_red
                running : delayAnimHarlem
                loops : Animation.Infinite
                PropertyAnimation {target:effectred;properties: "color"; to: "orange"; duration: 1000; }
                PropertyAnimation {target:effectred; properties: "color"; to: "yellow"; duration: 1000; }
                PropertyAnimation {target:effectred; properties: "color"; to: "red"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_red
                running : delayAnimHarlem
                loops : Animation.Infinite
                NumberAnimation{ target: cube_red;property: "scale"; to: 0.80;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 500 }
                NumberAnimation {target: cube_red;property: "scale";to: 1.7;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_red; target: zRT; running: delayAnimHarlem; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }

        }

        Cube
        {
            id : cube_blue
            effect: Effect {id : effectblue;color: "blue"}
            scale : 1
            position : Qt.vector3d(-2, 1, 0)
            transform: [
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {
                    id: yRT
                    angle: 0
                    axis: Qt.vector3d(0, -1, 0)
                }
            ]
            onClicked:{cube_plugin.effect.color = "blue";}
            SequentialAnimation {
                id : color_animation_blue
                running : delayAnimHarlem
                loops : Animation.Infinite
                PropertyAnimation {target:effectblue;properties: "color"; to: "yellow"; duration: 1000; }
                PropertyAnimation {target:effectblue; properties: "color"; to: "red"; duration: 1000; }
                PropertyAnimation {target:effectblue; properties: "color"; to: "blue"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_blue
                running : delayAnimHarlem
                loops : Animation.Infinite
                NumberAnimation{ target: cube_blue;property: "scale"; to: 0.50;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 200 }
                NumberAnimation {target: cube_blue;property: "scale";to: 1.5;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_blue; target: yRT; running: delayAnimHarlem; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }


        }

    }


    Item3D
    {
        id : buttonsHS
        enabled : delayAnimHarlem
        Cube
        {
            id : cube_yellow
            effect: Effect {id:effectyellow;color: "yellow"}
            scale : 1
            position : Qt.vector3d(-3, 1, -2)
            onClicked:{cube_plugin.effect.color = "yellow";}
            transform: [
                Rotation3D {
                    id : xRTyellow
                    angle: 0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, -1, 0)
                }
            ]
            SequentialAnimation {
                id : color_animation_yellow
                running : true
                loops : Animation.Infinite
                PropertyAnimation {target:effectyellow;properties: "color"; to: "blue"; duration: 1000; }
                PropertyAnimation {target:effectyellow; properties: "color"; to: "orange"; duration: 1000; }
                PropertyAnimation {target:effectyellow; properties: "color"; to: "yellow"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_yellow
                running : true
                loops : Animation.Infinite
                NumberAnimation{ target: cube_yellow;property: "scale"; to: 0.30;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 200 }
                NumberAnimation {target: cube_yellow;property: "scale";to: 0.80;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_yellow; target: xRTyellow; running: true; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }
        }

        Cube
        {
            id : cube_green
            effect: Effect {id:effectgreen;color: "green";}
            scale : 1
            position : Qt.vector3d(5, 1, -3)
            onClicked:{cube_plugin.effect.color = "green";}
            transform: [
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    id : zRTgreen
                    angle: 0.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, -1, 0)
                }
            ]
            SequentialAnimation {
                id : color_animation_green
                running : true
                loops : Animation.Infinite
                PropertyAnimation {target:effectgreen;properties: "color"; to: "orange"; duration: 1000; }
                PropertyAnimation {target:effectgreen; properties: "color"; to: "red"; duration: 1000; }
                PropertyAnimation {target:effectgreen; properties: "color"; to: "green"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_green
                running : true
                loops : Animation.Infinite
                NumberAnimation{ target: cube_green;property: "scale"; to: 1;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 800 }
                NumberAnimation {target: cube_green;property: "scale";to: 3.5;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_green; target: zRTgreen; running: true; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }

        }
        Cube
        {
            id : cube_violet
            effect: Effect {id:effectviolet;color: "violet"}
            scale : 1
            position : Qt.vector3d(0, 1, 2)
            transform: [
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(1, 0, 0)
                },
                Rotation3D {
                    angle: 45.0
                    axis: Qt.vector3d(0, 0, 1)
                },
                Rotation3D {
                    id: yRTviolet
                    angle: 0
                    axis: Qt.vector3d(-2, -1, 0)
                }
            ]
            onClicked:{cube_plugin.effect.color = "violet";}
            SequentialAnimation {
                id : color_animation_violet
                running : true
                loops : Animation.Infinite
                PropertyAnimation {target:effectviolet;properties: "color"; to: "red"; duration: 1000; }
                PropertyAnimation {target:effectviolet; properties: "color"; to: "green"; duration: 1000; }
                PropertyAnimation {target:effectviolet; properties: "color"; to: "violet"; duration: 1000;}
            }
            SequentialAnimation {
                id : scale_animation_violet
                running : true
                loops : Animation.Infinite
                NumberAnimation{ target: cube_violet;property: "scale"; to: 2.5;duration : 1500;easing.type: Easing.InOutElastic}
                PauseAnimation { duration: 200 }
                NumberAnimation {target: cube_violet;property: "scale";to: 1.8;duration : 1500; easing.type: Easing.InOutElastic}
            }
            RotationAnimation {id :ra_violet; target: yRTviolet; running: true; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }
        }
    }

    Item3D
    {
        id : cube_plugin
        mesh: Mesh { source: "./Batman.obj" }
        scale : 0.03
        position : Qt.vector3d(0, -5, 0)
        effect: Effect {color :"black"; useLighting : true}
        // APPLY TRANSFORMATIONS SO THAT PLUGIN MODEL FACES US
        transform : [Rotation3D {id : yBat; angle : 180; axis : Qt.vector3d(0, 1, 0)}]

        SequentialAnimation
        {
            id : scale_animation_bat
            running : delayAnimHarlem
            loops : Animation.Infinite
            NumberAnimation{ target: cube_plugin;property: "scale"; to:0.04;duration : 1500;easing.type: Easing.InOutElastic}
            PauseAnimation { duration: 200 }
            NumberAnimation {target: cube_plugin;property: "scale";to: 0.02;duration : 1500; easing.type: Easing.InOutElastic}
        }
        RotationAnimation {id :ra_bat; target: yBat; running: true; loops: Animation.Infinite; property: "angle"; from: 0; to : 360.0; duration: 3000; }

        /*        SequentialAnimation {
            id : animation_bat
            running : true
            loops : Animation.Infinite
            NumberAnimation{ target: yBat;
                property: "angle";
                from : 0;
                to: 360;
                duration : 1000;
                easing.type: Easing.InOutElastic
            }
        }*/
        onClicked :
        {
            console.log("plugin clicked");
            if (plugin_base.getFocusState() === 0)
                plugin_base.askForRoomSelectedFocusState();
            if (plugin_base.getFocusState() === 1)
                plugin_base.askForFocusedFocusState();
        }

        onPressed :
        {
            console.log("Plugin Pressed")
            savedX = -10000;
            savedY = -10000;
        }

        onHoverMove :
        {
        }

        SequentialAnimation {
            id : animation
            running : false
            loops : Animation.Infinite
            NumberAnimation{ target: cube_plugin;
                property: "scale";
                to: 0.95;
                duration : 200;
                easing.type: Easing.InOutElastic
            }
            PauseAnimation { duration: 100 }
            NumberAnimation {
                target: cube_plugin;
                property: "scale";
                to: 1;
                duration : 200;
                easing.type: Easing.InOutElastic
            }
        }
    }
}


