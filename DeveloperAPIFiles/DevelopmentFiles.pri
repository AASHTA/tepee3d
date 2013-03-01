
SOURCES += $$PWD/Plugins/PluginBase.cpp         \
           $$PWD/Plugins/PluginModelItem.cpp    \
           $$PWD/Rooms/RoomBase.cpp             \
           $$PWD/Rooms/RoomProperties.cpp       \
           $$PWD/Models/ListModel.cpp           \
           $$PWD/Models/SubListedListModel.cpp

HEADERS += $$PWD/Plugins/PluginInterface.h	\
           $$PWD/Plugins/PluginModelItem.h	\
           $$PWD/Plugins/PluginBase.h		\
           $$PWD/Services/ServiceInterface.h    \
           $$PWD/Services/DatabaseServiceUserInterface.h \
           $$PWD/Services/WebServiceUserInterface.h      \
           $$PWD/Rooms/RoomInterface.h          \
           $$PWD/Rooms/RoomBase.h               \
           $$PWD/Rooms/RoomProperties.h         \
           $$PWD/Models/ListModel.h             \
           $$PWD/Models/ListItem.h              \
           $$PWD/Models/SubListedListModel.h    \
           $$PWD/Models/SubListedListItem.h     \
           $$PWD/Plugins/PluginEnums.h          \
           $$PWD/View/QmlContentExposerInterface.h


INCLUDEPATH += $$PWD
INCLUDEPATH += $$PWD/Plugins
INCLUDEPATH += $$PWD/Services
INCLUDEPATH += $$PWD/Models
INCLUDEPATH += $$PWD/Rooms
INCLUDEPATH += $$PWD/View

OTHER_FILES +=  $$PWD/qml/Carousel.qml \
                $$PWD/qml/PluginBase.qml \
                $$PWD/qml/qmldir \
                $$PWD/js/CameraManagement.js \
                $$PWD/qml/UIComponents/qmldir \
                $$PWD/qml/UIComponents/TextInputComponent.qml \
                $$PWD/qml/Resources/Pictures/text_input_border.png \
                $$PWD/qml/Resources/Pictures/text_input_border_selected.png \
                $$PWD/qml/FileExplorer.qml \
                $$PWD/qml/FileDelegate.qml \
                $$PWD/qml/FolderDelegate.qml \
                $$PWD/qml/FileLoader.qml

QT += sql
