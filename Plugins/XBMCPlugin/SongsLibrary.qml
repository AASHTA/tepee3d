import QtQuick 2.1

GridView
{
    id : songs_library_gridview
    anchors.fill: parent
    cellWidth : width / 5
    cellHeight : cellWidth
    model : xbmc_plugin.getSongsLibrary();
    delegate : LibraryGridViewDelegate {
        id : song_delegate
        width : songs_library_gridview.cellWidth
        height :songs_library_gridview.cellHeight
        thumbnail: (model.thumbnail !== "") ? xbmc_plugin.getXBMCImageProviderUrl(model.thumbnail) : "empty_cd.png"
        title : model.title

        AddButton
        {
            width : 50
//            scale : song_delegate.scale
            anchors
            {
                right : song_delegate.right
                bottom : song_delegate.bottom
                bottomMargin : 10
            }
            onClicked : {xbmc_plugin.addSongToPlaylist(model.songId); console.log(model.songId)}
        }

        Image
        {
            id : play_button
            height : 60
            fillMode: Image.PreserveAspectFit
            source : "small_play.png"
            scale : play_button_ma.pressed ? 0.9 : 1
            anchors
            {
                right : song_delegate.right
                top : song_delegate.top
                topMargin : 10
            }
            MouseArea
            {
                id : play_button_ma
                anchors.fill: parent
                onClicked:
                {
                    xbmc_plugin.playFile(model.file)
                }
            }
        }
    }
}
