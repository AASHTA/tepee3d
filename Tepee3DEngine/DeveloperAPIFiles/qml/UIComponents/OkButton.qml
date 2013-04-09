import QtQuick 2.0

Image
{
    id : ok_button
    signal clicked()
    height : 50
    width : 50
    scale : ok_button_ma.pressed ? 0.9 : 1
    source : "ok.png"
    fillMode: Image.PreserveAspectFit
    MouseArea
    {
        id : ok_button_ma
        anchors.fill: parent
        onClicked: {ok_button.clicked()}
    }
}
