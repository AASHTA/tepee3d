import QtQuick 2.0

Item
{
    id : album_library_item
    property  bool albumView : false
    anchors.fill: parent
    states : [
        State
        {
            name : "library_view"
            AnchorChanges
            {
                target : albums_library_gridview
                anchors.top: album_library_item.top
            }
            AnchorChanges
            {
                target : album_view
                anchors.bottom : album_library_item.top
            }
            when : !albumView
        },
        State
        {
            name : "album_view"
            AnchorChanges
            {
                target : albums_library_gridview
                anchors.top: album_library_item.bottom
            }
            AnchorChanges
            {
                target : album_view
                anchors.bottom : album_library_item.bottom
            }
            when : albumView
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: 250 }
    }

    Item
    {
        id : album_view
        property alias thumbnail : album_thumbnail.source
        property alias albumTitle : album_title_text.text
        property alias albumSummary : album_summary.text
        property alias songModel : album_songs_listview.model
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            topMargin : 5
            bottomMargin : 5
        }
        Item
        {
            id : album_detail_item
            width : parent.width / 3
            anchors
            {
                left : parent.left
                top : parent.top
                bottom   : parent.bottom
            }
            clip : true
            Rectangle
            {
                anchors.fill: parent
                smooth : true
                border
                {
                    width : 1
                    color : "white"
                }
                color : "black"
                opacity : 0.1
                radius : 5
            }
            Item
            {
                id : thumbnail_shadow_item
                width : album_thumbnail.paintedWidth
                height : album_thumbnail.paintedHeight
                anchors.centerIn: album_thumbnail
            }

            Rectangle
            {
                width : album_thumbnail.paintedWidth
                height : album_thumbnail.paintedHeight
                anchors
                {
                    top : thumbnail_shadow_item.top
                    left : thumbnail_shadow_item.left
                    leftMargin : 8
                    topMargin : 8
                }
                radius : 2
                color : "#44000000"
                scale : album_thumbnail.scale
            }
            Image
            {
                id : album_thumbnail
                width: parent.width - 40
                fillMode: Image.PreserveAspectFit
                Behavior on scale {NumberAnimation {duration : 1200; easing.type: Easing.InOutBack}}
                scale : (status == Image.Ready) ? 1 : 0
                anchors
                {
                    top : parent.top
                    topMargin : 20
                    horizontalCenter : parent.horizontalCenter
                }
            }
            Text
            {
                id : album_title_text
                width : parent.width
                clip : true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                color : "white"
                anchors
                {
                    top : album_thumbnail.bottom
                    topMargin : 15
                    horizontalCenter : parent.horizontalCenter
                }
                font.pixelSize: mainWindow.largeFontSize
            }
            Flickable
            {
                anchors
                {
                    top : album_title_text.bottom
                    topMargin : 5
                    bottom : parent.bottom
                    left : parent.left
                    right : parent.right
                }
                clip : true
                contentWidth: width
                contentHeight: album_summary.height
                Text
                {
                    id : album_summary
                    color : "white"
                    font.pixelSize: mainWindow.defaultFontSize
                }
            }
        }
        ListView
        {
            id : album_songs_listview
            clip : true
            anchors
            {
                left : album_detail_item.right
                right : parent.right
                top : parent.top
                bottom : back_button_album_detail.top
                leftMargin : 10
            }
            delegate : Component {
                Item
                {
                    width : album_songs_listview.width
                    height : album_songs_listview.height / 6

                    Image
                    {
                        id : song_thumbnail
                        height: parent.height - 20
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {NumberAnimation {duration : 1200; easing.type: Easing.InOutBack}}
                        scale : (status == Image.Ready) ? 1 : 0
                        anchors
                        {
                            left : parent.left
                            leftMargin : 5
                            verticalCenter : parent.verticalCenter
                        }
                        smooth : true
                        source : (model.thumbnail !== "") ? XBMCPlugin.getXBMCImageProviderUrl(model.thumbnail) : "empty_cd.png"
                    }
                    Text
                    {
                        id : song_title
                        color : "white"
                        width : parent.width / 2
                        wrapMode: Text.WrapAnywhere
                        anchors
                        {
                            left : song_thumbnail.right
                            leftMargin : 15
                            verticalCenter : parent.verticalCenter
                        }
                        font.pixelSize: mainWindow.defaultFontSize
                        text : model.title
                    }
                    Text
                    {
                        id : song_duration
                        color : "white"
                        wrapMode: Text.WrapAnywhere
                        anchors
                        {
                            right : play_button.left
                            verticalCenter : parent.verticalCenter
                            rightMargin : 5
                        }
                        font.pixelSize: mainWindow.defaultFontSize
                        text : Math.floor(((model.runtime % 3600) / 60)) + ":" + Math.floor(((model.runtime % 3600) % 60))
                    }
                    Image
                    {
                        id : play_button
                        height : Math.max(parent.height / 2, 75)
                        fillMode: Image.PreserveAspectFit
                        source : "player_play.png"
                        scale : play_button_ma.pressed ? 0.9 : 1
                        anchors
                        {
                            right : parent.right
                            verticalCenter : parent.verticalCenter
                        }
                        MouseArea
                        {
                            id : play_button_ma
                            anchors.fill: parent
                            onClicked:
                            {
                                console.log("Play Button Pressed to play file " + model.file)
                                XBMCPlugin.playFile(model.file)
                            }
                        }
                    }

                }
            }
        }

        BackButton
        {
            id : back_button_album_detail
            width : 50
            onClicked : {album_library_item.albumView = false}
            anchors
            {
                right : parent.right
                bottom : parent.bottom
                margins : 5
            }
        }
    }

    GridView
    {
        id : albums_library_gridview
        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        cellWidth : width / 5
        cellHeight : cellWidth
        model : XBMCPlugin.getAlbumsLibrary();
        clip : true
        delegate : LibraryGridViewDelegate {
            width : albums_library_gridview.cellWidth
            height :albums_library_gridview.cellHeight
            thumbnail: (model.thumbnail !== "") ? XBMCPlugin.getXBMCImageProviderUrl(model.thumbnail) : "empty_cd.png"
            title : model.albumTitle
            onClicked:
            {
                album_view.albumTitle = model.albumTitle + " (" + model.albumYear +")"
                album_view.thumbnail = thumbnail
                album_view.albumSummary = model.description
                album_view.songModel = albums_library_gridview.model.subModelFromId(model.albumId)
                albumView = true;
            }
        }
    }
}
