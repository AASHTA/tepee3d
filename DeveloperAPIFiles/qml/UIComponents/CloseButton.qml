import QtQuick 2.0

Image
{
    id : close_button
    signal clicked()
    height : 50
    width : 50
    scale : close_button_ma.pressed ? 0.9 : 1
    source : "red_cross.png"
    fillMode: Image.PreserveAspectFit
    MouseArea
    {
        id : close_button_ma
        anchors.fill: parent
        onClicked: {close_button.clicked()}
    }
}
