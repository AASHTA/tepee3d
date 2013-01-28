// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Item
{
    id : menuRightMain
    width: minMenuWidth
    height: minMenuHeight
    x : minMenuX

    property bool isShown : false
    property int  minMenuWidth : mainWindow.menuMinimumWidth
    property int  maxMenuWidth : mainWindow.width / 3
    property int  minMenuX : mainWindow.width - minMenuWidth
    property int  maxMenuX : mainWindow.width - maxMenuWidth
    property int  minMenuHeight : mainWindow.height / 2
    //    property int  minMenuHeight : mainWindow.height
    property int  maxMenuHeight : mainWindow.height
    property int  xSaved;
    property int  savedWidth;

    function startDrag(xPos, yPos)
    {
        xSaved = xPos;
    }

    function dragMoved(offsetX, offsetY)
    {
        var newX = offsetX + xSaved;
        if (newX <= minMenuX && newX >= maxMenuX)
        {
//            menuRightMain.x = newX
//            menuRightMain.width = mainWindow.width - newX;
            savedWidth = mainWindow.width - newX;
        }
    }

    function dragEnd()
    {
        if ((savedWidth - minMenuWidth) / maxMenuWidth > 0.4)
            menuRightMain.isShown = true;
        else
            menuRightMain.isShown = false;
    }

    states :     [
        State     {
            name: "menuShown"
            PropertyChanges
            {
                target: menuRightMain;
                width : maxMenuWidth
                height : maxMenuHeight
                x: maxMenuX
            }
            PropertyChanges
            {
                target: menuRightRec
                opacity : mainWindow.menu_opacity_deployed
            }
            PropertyChanges
            {
                target : room_plugins_list_view
                opacity : 1
            }
            PropertyChanges
            {
                target : add_plugin_button
                opacity : 1
            }
            when: menuRightMain.isShown
        },
        State {
            name: "menuHidden"
            PropertyChanges
            {
                target: menuRightMain
                x : minMenuX
                height : minMenuHeight
                width : minMenuWidth
            }
            PropertyChanges
            {
                target: menuRightRec
                opacity : mainWindow.menu_opacity_retracted
            }
            PropertyChanges
            {
                target : add_plugin_button
                opacity : 0
            }
            PropertyChanges
            {
                target : room_plugins_list_view
                opacity : 0
            }
            when: !menuRightMain.isShown
        }]

    transitions :    [
        Transition
        {
            from: "menuHidden"
            to: "menuShown"
            NumberAnimation
            {
                target : menuRightRec
                properties : "x, width, opacity"
                duration : 400
            }
            NumberAnimation
            {
                target : room_plugins_list_view
                properties : "opacity"
                duration : 250
            }
        },
        Transition
        {
            from: "menuShown"
            to: "menuHidden"
            NumberAnimation
            {
                target : menuRightRec
                properties : "x, width, opacity"
                duration : 200
            }
            NumberAnimation
            {
                target : room_plugins_list_view
                properties : "opacity"
                duration : 150
            }
        }
    ]

    BorderImage
    {
        id : menuRightRec
        width : parent.width
        height : parent.height
        //        color : mainWindow.menu_background_color
        source : "Resources/Pictures/panel_bg2.png"
        property bool add_plugins : false;
        opacity : 0

        border
        {
            left : 2
            bottom : 1
        }


        states : [
            State
            {
                name : "currentRoomPlugins"
                AnchorChanges
                {
                    target : available_plugins_rect
                    anchors.left : menuRightRec.right
                }
                when : !menuRightRec.add_plugins
            },
            State
            {
                name : "availablePlugins"
                AnchorChanges
                {
                    target : available_plugins_rect
                    anchors.left : menuRightRec.left
                }
                when : menuRightRec.add_plugins
            }
        ]
        transitions: [
            Transition
            {
                from: "currentRoomPlugins"
                to: "availablePlugins"
                AnchorAnimation
                {
                    duration : 500
                    easing.type: Easing.OutQuad
                }
            },
            Transition
            {
                from: "availablePlugins"
                to: "currentRoomPlugins"
                AnchorAnimation
                {
                    duration : 500
                    easing.type: Easing.InQuart
                }
            }
        ]

        ListView
        {
            id : room_plugins_list_view

            property real delegate_width :  menuRightMain.width / 2;
            property real delegate_height : menuRightMain.width / 3;

            opacity : 0
            enabled : (parent.opacity == 1)
            clip: true
            anchors
            {
                fill: parent
                margins : menuRightMain.width / 8
            }
            orientation: ListView.Vertical
            model : roomModel.subModelFromId(mainWindow.currentRoomId);
            delegate: RoomPluginDelegate {
                width : menuRightMain.width / 2
                height : menuRightMain.width / 3
                pluginName: model.pluginName
            }
            spacing: 10
        }

        Rectangle
        {
            id : available_plugins_rect
            width : parent.width
            height : parent.height
            enabled : menuRightRec.add_plugins
            color : "transparent"

            anchors
            {
                left : parent.right
            }

            ListView
            {
                id : available_plugins_list_view
                opacity : 1
                enabled : (parent.opacity == 1)
                clip: true
                spacing: 10
                anchors
                {
                    fill: parent
                    left : parent.right
                    margins : menuRightMain.width / 8
                }
                orientation: ListView.Vertical
                model : availablePluginsModel
                delegate: NewPluginDelegate {
                    width : menuRightMain.width / 2
                    height : menuRightMain.width / 3
                    pluginName: model.pluginName
                }
            }
        }

        Image
        {
            id : add_plugin_button
            width : 50
            height : 50
            smooth : true
            scale : add_plugin_button_ma.pressed ? 0.9 : 1.0
            anchors
            {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
            }
            MouseArea
            {
                id : add_plugin_button_ma
                anchors.fill : parent
                onClicked :
                {
                    menuRightRec.add_plugins = !menuRightRec.add_plugins
                }
            }

            source : "Resources/Pictures/add_button.svg"
        }

        //        Component
        //        {
        //            id : plugin_list_delegate
        //        }

    }
}
