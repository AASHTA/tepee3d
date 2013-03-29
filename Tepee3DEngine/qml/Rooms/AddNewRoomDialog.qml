import QtQuick 2.0

Item
{
    id : addNewRoomDialog
    x : 400
    y : 400
    width : 350
    height : 100
    property string roomName : "room"

    BorderImage
    {
        id : addNewRoomDialogRec
        width : parent.width
        height : parent.height
        opacity : 1
        source : "../Resources/Pictures/panel_bg2.png"
    }
    TextInput {
        id : addNewRoomDialogTitle
        color: "grey"
        text: "New room name"
    }

    TextInputComponent
    {
        id : roomName
        anchors.centerIn: parent
        width : 250
    }

        BorderImage
        {
            id : addNewRoomDialogCancelButton
            anchors.left : parent.left
            anchors.bottom : parent.bottom
            width: 75
            height : 30
            opacity : 1
            source : "../Resources/Pictures/delegate.png"
            Text {
                id : addNewRoomDialogCancelButtonText
                text: "Cancel"
                anchors.centerIn: parent
            }
            MouseArea {
                id : addNewRoomDialogCancelButtonAction
                anchors.fill: parent
                onClicked: {
                    // code
                   }
            }
        }

        BorderImage
        {
            id : addNewRoomDialogValideButton
            anchors.right : parent.right
            anchors.bottom : parent.bottom
            width: 75
            height : 30
            opacity : 1
            source : "../Resources/Pictures/delegate.png"
            Text {
                id : addNewRoomDialogValideButtonText
                text: "Ok"
                anchors.centerIn: parent
            }
            MouseArea {
                id : addNewRoomDialogValideButtonAction
                anchors.fill: parent
                onClicked: {
                    //
                   }
            }
        }

}
