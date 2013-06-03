import QtQuick 2.0

Item
{
    anchors.fill: parent
    GridView
    {
        id : movies_library_gridview
        anchors.fill: parent
        model : XBMCPlugin.getMoviesLibrary();
        cellWidth : width / 5
        cellHeight : cellWidth
        delegate : Component {
            Item
            {
                width : movies_library_gridview.cellWidth
                height : movies_library_gridview.cellHeight
                Image
                {
                    id : movie_image
                    height : parent.height - 30
                    anchors
                    {
                        topMargin : 5
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                    }
                    asynchronous : true
                    fillMode: Image.PreserveAspectFit
                    source : XBMCPlugin.getXBMCImageProviderUrl(model.thumbnail)
                    onStatusChanged: {if (status == Image.Error) source = "empty_cd.png"}
                    Behavior on scale {NumberAnimation {duration : 1200; easing.type: Easing.InOutBack}}
                    scale : (status == Image.Ready) ? 1 : 0
                }
                Image
                {
                    id : cd_cover
                    source : "dvdbox.png"
                    anchors
                    {
                        left : movie_image.left
                        leftMargin : -23
                        right : movie_image.right
                        rightMargin : -5
                        top : movie_image.top
                        topMargin : -4
                        bottom : movie_image.bottom
                        bottomMargin : -6
                    }
                     scale :movie_image.scale
                }
                Text
                {
                    id : title_text
                    text : model.title
                    width : parent.width
                    color : "white"
                    font.pixelSize: mainWindow.defaultFontSize
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    clip : true
                    anchors
                    {
                        bottom : parent.bottom
                        bottomMargin : 8
                    }
                }
            }
        }
    }
}
