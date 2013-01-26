// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import "js/Walls.js" as Walls;

Item
{
    id : menuTopMain
    width: minMenuWidth
    height: minMenuHeight
    property bool isShown : false
    property int  minMenuHeight : mainWindow.menuMinimumWidth
    property int  maxMenuHeight : mainWindow.height / 2
    property int  minMenuWidth : mainWindow.width / 2
    property int  maxMenuWidth : mainWindow.width
    property int  ySaved;
    property int  savedHeight;


    Component.onCompleted:
    {
        mainWindow.roomFaceIdChanged.connect(setListIndex)
    }


    function startDrag(xPos, yPos)
    {
        ySaved = yPos;
        savedHeight = menuTopMain.height
    }

    function dragMoved(offsetX, offsetY)
    {
        var offset = offsetY;
        if ((savedHeight + offset) <=  maxMenuHeight &&
                (savedHeight + offset) >= minMenuHeight)
            menuTopMain.height = savedHeight + offset;
    }

    function  dragEnd()
    {
        if ((menuTopMain.height - minMenuHeight) / maxMenuHeight > 0.4)
        {
            if (menuTopMain.isShown)
                menuTopMain.isShown = false;
            menuTopMain.isShown = true;
        }
        else
        {
            if (!menuTopMain.isShown)
                menuTopMain.isShown = true;
            menuTopMain.isShown = false;
        }
    }

    function setListIndex(wallId)
    {
        console.log("Wall ID <><><><><><><><> " + wallId)
        room_faces_listview.currentIndex = wallId;
    }

    states :     [
        State     {
            name: "menuShown"
            PropertyChanges
            {
                target: menuTopMain;
                height : maxMenuHeight
                width : maxMenuWidth
            }
            PropertyChanges
            {
                target: menuTopRec
                height : maxMenuHeight
                width : maxMenuWidth
                opacity : mainWindow.menu_opacity_deployed
            }
            PropertyChanges
            {
                target : room_faces_listview
                opacity : 1
            }
            when: menuTopMain.isShown
        },
        State {
            name: "menuHidden"
            PropertyChanges
            {
                target: menuTopMain
                height : minMenuHeight
                width : minMenuWidth
            }
            PropertyChanges
            {
                target: menuTopRec
                opacity : 0.3
            }
            PropertyChanges
            {
                target : room_faces_listview
                opacity : 0
            }
            when: !menuTopMain.isShown
        }]

    BorderImage
    {
        id : menuTopRec
        width : parent.width
        height : parent.height
        source : "Resources/Pictures/panel_bg2.png"
        //        color : mainWindow.menu_background_color
        opacity : 0
        //        Behavior on height {NumberAnimation {duration: 100}}
        //        Behavior on width {PropertyAnimation { properties: "width"; easing.type: Easing.OutBounce; duration : 500 }}
        //        Behavior on opacity {NumberAnimation {duration: 500}}

        border
        {
            left : 2
            bottom : 1
        }


        GridView
        {
//            Rectangle
//            {
//                anchors.fill: parent
//                color : "green"
//            }

            id : room_faces_listview
            cellWidth: width / 6
            cellHeight: cellWidth
//            property real delegate_width :  menuTopMain.height / 10;
//            property real delegate_height : menuTopMain.height / 12;

            clip : true
            opacity :  0
            enabled : (opacity == 1)
            Behavior on opacity {NumberAnimation {duration : 500}}

            anchors
            {
                left : parent.left
                top : parent.top
                bottom : parent.bottom
                right : parent.right
                margins : menuTopRec.height / 8
            }

            delegate : room_face_view_delegate
            model : currentRoomFacesModel
            Component.onCompleted:
            {
                room_faces_listview.currentIndex = -1;
            }
        }



        Component
        {
            id : room_face_view_delegate
            Item
            {
                id : room_face_del_item
                width : room_faces_listview.cellWidth
                height : room_faces_listview.cellHeight
               // anchors.verticalCenter: parent.verticalCenter
                scale : room_face_delegate_mouse_area.pressed ? 0.9 : 1.0
                MouseArea
                {
                    id : room_face_delegate_mouse_area
                    anchors.fill : parent
                    onClicked :
                    {
                        room_faces_listview.currentIndex = index
//                        moveToFace(model.idx)
                        mainWindow.currentRoomFaceId = index;
                    }
                }

                Rectangle
                {
                    color : (room_faces_listview.currentIndex == index) ? mainWindow.room_list_selected_component_color: mainWindow.room_list_component_color
                    anchors.fill: parent
                    anchors.margins: 10
                }

                Text
                {
                    anchors
                    {
                        centerIn : parent
                    }
                    text : model.name
                }
            }
        }

        Text
        {

            text : getTime();

            Timer
            {
                running: true
                interval : 60000
                onTriggered:
                {
                    parent.text = parent.getTime();
                }
            }


            function getTime()
            {
                var d = new Date();
                return d.getHours() + ":" + d.getMinutes();
            }

            color : "white"
            anchors
            {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
                margins : 10
            }
        }
    }

}
