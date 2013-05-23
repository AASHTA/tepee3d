#-------------------------------------------------
#-------------------------------------------------
#
# Project created by QtCreator 2012-06-09T11:42:49
#
#-------------------------------------------------

qml_folder.source = ../../Tepee3DEngine/plugins_qml
qml_folder.target = ./


 TEMPLATE        = lib
 CONFIG         += qt plugin
 QT             += quick

HEADERS         = \
    TestPlugin.h

 SOURCES         = \
    TestPlugin.cpp

#include development files
include (../../Tepee3DEngine/DeveloperAPIFiles/DevelopmentFiles.pri)

 TARGET          = TestPlugin                    #NAME OF THE PLUGIN LIBRAY
 DESTDIR         = ../../Tepee3DEngine/libraries/widget_libraries             #WHERE TO PUT THE LIBRARY
 DESTDIRQML      = qml_folder

# # install
# target.path = plugins/build
# sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS plugin.pro
# sources.path = ../plugins
# INSTALLS += target sources

OTHER_FILES += \
    qmldir \
    qmltestplugin.qmlproject \
    Menu.qml    \
    images/texture0.jpg \
    Batman/Cape.obj \
    Batman/Cape.mtl \
    Batman/Cape.lwo \
    Batman/BatmanArmoured.obj \
    Batman/BatmanArmoured.mtl \
    Batman/BatmanArmoured.lwo \
    Batman/Batman.obj \
    Batman/Batman.mtl \
    Batman/Batman.lwo \
    Batman/V2_Batman_Head_S.tga \
    Batman/V2_Batman_Head_N.tga \
    Batman/V2_Batman_Head_D.tga \
    Batman/V2_Batman_Cape_S2.tga \
    Batman/V2_Batman_Cape_N2.tga \
    Batman/V2_Batman_Cape_D2.tga \
    Batman/V2_Batman_Cape_A2.tga \
    Batman/V2_Batman_Body_S.tga \
    Batman//V2_Batman_Body_N.tga \
    Batman/V2_Batman_Body_D.tga \
    Batman/BatmanEye_N_2.tga \
    Batman/BatmanEye_D.tga \
    Batman/BatmanArmoured_Head_S.tga \
    Batman/BatmanArmoured_Head_N.tga \
    Batman/BatmanArmoured_Head_D.tga \
    Batman/BatmanArmoured_Body_S.tga \
    Batman/BatmanArmoured_Body_N.tga \
    Batman/BatmanArmoured_Body_D.tga \
    js/xauth.js \
    js/twitter.js \
    js/translate.js \
    js/script.js \
    js/pocket.js \
    js/lib/sha1.js \
    TestPlugin.qml \
    js/storage.js \
    storage.qml

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

#FOR BLACKBERRY PLAYBOOK
#qnx {
#    QMAKE_LFLAGS += '-Wl,-rpath,\'./app/native/lib\''

#    PACKAGE_ARGS = \
#        $${PWD}/bar-descriptor.xml $$TARGET \
#        -e $${PWD}/icon.png res/icon.png \
#        -e $$[QT_INSTALL_LIBS]/libQtCore.so.5 lib/libQtCore.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtGui.so.5 lib/libQtGui.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtOpenGL.so.5 lib/libQtOpenGL.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtNetwork.so.5 lib/libQtNetwork.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtWidgets.so.5 lib/libQtWidgets.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtQuick.so.5 lib/libQtQuick.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtQml.so.5 lib/libQtQml.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtSql.so.5 lib/libQtSql.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtV8.so.5 lib/libQtV8.so.5 \
#        -e $$[QT_INSTALL_LIBS]/libQtXmlPatterns.so.5 lib/libQtXmlPatterns.so.5 \
#        -e $$[QT_INSTALL_PLUGINS]/platforms/libqnx.so plugins/platforms/libqnx.so \
#        -e $$[QT_INSTALL_IMPORTS]/ imports/

#    package.target = $${TARGET}.bar
#    package.depends = $$TARGET
#    package.commands = blackberry-nativepackager \
#        -package $${TARGET}.bar \
#        -devMode -debugToken $$(DEBUG_TOKEN) \
#        $${PACKAGE_ARGS}

#    QMAKE_EXTRA_TARGETS += package

#    OTHER_FILES += bar-descriptor.xml
#}




# deploy qml files to correct dir
copyToDestDir($$OTHER_FILES)
