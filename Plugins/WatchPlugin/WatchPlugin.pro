qml_folder.source = ../../Tepee3DEngine/plugins_qml
qml_folder.target = ./

  TEMPLATE        = lib
  CONFIG         += qt plugin
  QT             += quick
  QT             += widgets

 #include development files
    include (../../Tepee3DEngine/DeveloperAPIFiles/DevelopmentFiles.pri)

 TARGET          = WatchPlugin
 DESTDIR         = ../../Tepee3DEngine/libraries/widget_libraries
 DESTDIRQML      = qml_folder
# Copies the given files to the destination directory
defineTest(copyToDestDir) {
    files = $$1
    unix {
        QMAKE_POST_LINK  += rm -fr $$qml_folder.source/$$TARGET $$escape_expand(\\n\\t)
        QMAKE_POST_LINK  += mkdir $$qml_folder.source/$$TARGET $$escape_expand(\\n\\t)
    }
    win32 {
        DDIR = ..\..\Tepee3DEngine\plugins_qml\\$$TARGET
        DESTDIR_WIN = $${DDIR}
        DESTDIR_WIN ~= s,/,\\,g
        QMAKE_POST_LINK +=$$quote(cmd /c  if not exist $${DDIR}\NUL\\$$escape_expand(\n\t) mkdir  $${DDIR}$$escape_expand(\n\t))
    }
    for(FILE, files) {
        DDIR = $$qml_folder.source/$$TARGET/

        win32{
        DDIR =  ..\..\Tepee3DEngine\plugins_qml\\$$TARGET
        FILE ~= s,/,\\,g
        QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DDIR}$$escape_expand(\n\t))
        }

        unix:QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DDIR) $$escape_expand(\\n\\t)
    }
    message($$QMAKE_POST_LINK)
    export(QMAKE_POST_LINK)
}

HEADERS += \
    WatchPlugin.h \
    WatchPlugin.h \
    ClockListItem.h

SOURCES += \
    WatchPlugin.cpp \
    ClockListItem.cpp


OTHER_FILES += \
    WatchPlugin.qml \
    Menu.qml \
    qmldir \
    WatchPlugin.qml \
    Menu.qml \
    qmldir \
    AlarmClock-2.dae \
    enhanced_led_board-7.ttf \
    ClockDelegate.qml \
    Clock.qml \
    second.png \
    minute.png \
    hour.png \
    clock-night.png \
    clock.png \
    center.png \
    background.png \
    plus.png \
    AddBox.qml \
    edit.png \
    delegate.png \
    EditBox.qml \
    RemoveBox.qml


# deploy qml files to correct dir
copyToDestDir($$OTHER_FILES)
