import QtQuick 2.0

Item
{
    id : notifications_item
    property bool   quickNotifIsShown : quick_notification.isShown;
    property bool   mainNotifIsShown  : main_notification.isShown;
    anchors.fill: parent

    Behavior on opacity {SmoothedAnimation {velocity : 10; duration : -1}}
    Component.onCompleted: {NotificationManagement.initialize()}

    function    sendMessage(message) // TYPE CAN BE ERROR / WARNING / QUICK
    {
        // MESSAGE IS A JSON OF THE FORM
        //        message =
        //                {
        //                    message : "textMessage", // NEEDED
        //                    type : 0,                // NEEDED
        //                    callback :               // OPTIONAL IF QUICK NOTIF
        //                    {
        //                        func : testCal,
        //                        context : this
        //                    }
        //                }
        // TYPE 0 -> Quick, 1 -> Confirmation (calls callback with true or false), 2 ->  Warning (Ok Button), 3 -> Error (Ok Button)

        // CALL THE GIVEN TYPE OF NOTIFICATION HERE
        // QUICK NOTIFICATIONS ARE RENDERED IN quick_notification ITEM
        // ALL OTHER NOTIFICATIONS ARE RENDERED IN main_notification ITEM

        //        console.log("<<<<< NOTIF ");

        // CALL CALLBACK TO BE EXECUTED IN THE CONTEXT OF SENDER
        //        message.callback.call(message.sender);
        //        callback.call(sender);

        // MESSAGES ARE SAVED IN CORRESPONDING QUEUE

        if (!message || (message.type === null) || !message.message)
            return;

        switch (message.type)
        {
        case 0: // QUICK NO CALLBACK NEEDED
            if (message.callback && message.callback.func && message.callback.context)
                NotificationManagement.addQuickMessage(message);
            if (!quickNotifIsShown)
                showNextQuickMessageInQueue();
            break;
        case 1: // Confirmation (CALLBACK WITH TRUE FALSE)
            if (message.callback && message.callback.func && message.callback.context)
                NotificationManagement.addMessage(message);
            if (!mainNotifIsShown)
                showNextMessageInQueue();
            break;
        case 2: // WARNING (CALLBACK NO PARAMS)
            NotificationManagement.addMessage(message);
            if (!mainNotifIsShown)
                showNextMessageInQueue();
            break;
        case 3: // ERROR (CALLBACK NO PARAMS)
            NotificationManagement.addMessage(message);
            if (!mainNotifIsShown)
                showNextMessageInQueue();
            break;
        }
    }

    onMainNotifIsShownChanged: {if (!mainNotifIsShown) showNextMessageInQueue()}
    onQuickNotifIsShownChanged: {if (!quickNotifIsShown) showNextQuickMessageInQueue()}

    function    showNextMessageInQueue()
    {
        var msg = null;
        if (NotificationManagement.nextMessage())
            msg = NotificationManagement.getNextMessage()
        if (msg)
        {
            console.log("Message retrieved");
            main_notification.isShown = true;
        }
    }

    function    showNextQuickMessageInQueue()
    {
        var msg = null;
        if (NotificationManagement.nextQuickMessage())
            msg = NotificationManagement.getNextQuickMessage()
        if (msg)
        {
            console.log("Message retrieved");
            quick_notification.isShown = true;
        }
    }

    // STORE MESSAGES IN A LIST
    // WHILE THERE ARE MESSAGES IN THE LIST SHOW THEM
    // THAT WAY IF MULTIPLE MESSAGES ARE SEND, NONE WILL BE LOST
    // DEFINE ALL MESSAGES TYPE WARNING, ERROR, YES/NO, OK .....

    SequentialAnimation
    {
        id : show_quick_notification
        SmoothedAnimation {velocity : 1; duration : -1;target : quick_notification; property : "opacity"; to : 1}
        PauseAnimation { duration: 1500 }
        SmoothedAnimation {velocity : 10; duration : -1;target : quick_notification; property : "opacity"; to : 0}
    }

    Item
    {
        id : main_notification
        property bool isShown : false;
        enabled : isShown
        width : mainWindow.width / 2
        height : mainWindow.height / 2
        anchors.centerIn: parent
        opacity : 0

        onIsShownChanged:
        {
            opacity = (isShown) ? 1 : 0;
            if (isShown)
            {
                button_validate.opacity = 0;
                button_ok.opacity = 0;
                button_cancel.opacity = 0;
                var msg = NotificationManagement.getLastMessage();
                if (msg && msg.type !== null)
                {
                    main_notification_text.text = msg.message;
                    switch (msg.type)
                    {
                    case 1:
                        button_validate.opacity = 1;
                        button_cancel.opacity = 1;
                        break;
                    case 2:
                        button_ok.opacity = 1;
                        break;
                    case 3:
                        button_ok.opacity = 1;
                        break;
                    }
                }
            }
        }

        BorderImage
        {
            id: background_main_notification
            source: "../Resources/Pictures/panel_bg2.png"
            anchors.fill: parent
        }

        Text
        {
            id : main_notification_text
            anchors.centerIn: background_main_notification
            color : "white"
        }

        Loader
        {
            anchors.fill: background_main_notification
            id : dialogLoader
        }

        Image
        {
            id : close_main_notification_button
            anchors {right : background_main_notification.right; bottom : background_main_notification.bottom}
            width : 50
            source : "../Resources/Pictures/red_cross.png"
            scale : (close_main_notification_ma.pressed) ? 0.9 : 1
            fillMode: Image.PreserveAspectFit
            MouseArea
            {
                id : close_main_notification_ma
                anchors.fill: parent
                onClicked:
                {
                    main_notification.opacity = 0;
                    // TRIGGER NEXT MESSAGE
                }
            }
        }
        // OK BUTTON
        Item
        {
            id : button_ok
            width : 50
            height : 50
            anchors
            {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
            }
            Rectangle
            {
                anchors.fill: parent
                color : "blue"
            }
            MouseArea
            {
                id : button_ok_ma
                anchors.fill: parent
                onClicked :
                {
                    var msg = NotificationManagement.getLastMessage()
                    if (msg && msg.callback && msg.callback.func && msg.callback.context)
                        msg.callback.func.call(msg.callback.context);
                }
            }
        }
        // VALIDATE BUTTON
        Item
        {
            id : button_validate
            width : 50
            height : 50
            anchors
            {
                bottom : parent.bottom
                right : parent.horizontalCenter
            }
            Rectangle
            {
                anchors.fill: parent
                color : "blue"
            }
            MouseArea
            {
                id : button_validate_ma
                anchors.fill: parent
                onClicked :
                {
                    var msg = NotificationManagement.getLastMessage()
                    if (msg)
                        msg.callback.func.call(msg.callback.context, true);
                }
            }
        }
        // CANCEL BUTTON
        Item
        {
            id : button_cancel
            width : 50
            height : 50
            anchors
            {
                bottom : parent.bottom
                left : parent.horizontalCenter
            }
            Rectangle
            {
                anchors.fill: parent
                color : "blue"
            }
            MouseArea
            {
                id : button_cancel_ma
                anchors.fill: parent
                onClicked :
                {
                    var msg = NotificationManagement.getLastMessage()
                    if (msg)
                        msg.callback.func.call(msg.callback.context);
                }
            }
        }
    }

    Item        // USED TO SIGNAL TWITTS, UPDATES ...
    {
        id : quick_notification
        property bool isShown : false;
        enabled : isShown
        opacity : 0

        onIsShownChanged :    {opacity = (isShown) ? 1 : 0;}

        width : mainWindow.width / 4
        height : 100

        anchors
        {
            right : parent.right
            verticalCenter : parent.verticalCenter
        }

        BorderImage
        {
            id: background_quick_notification
            source: "../Resources/Pictures/panel_bg2.png"
            anchors.fill: parent
        }

        Text
        {
            anchors.centerIn: background_quick_notification
            color : "white"
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked :
            {
            }
        }
    }
}

