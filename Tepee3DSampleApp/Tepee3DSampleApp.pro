# Add more folders to ship with the application, here
# Add more folders to ship with the application, here
folder_01.source = qml/Tepee3DSampleApp
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH = qml/Tepee3DSampleApp

symbian:TARGET.UID3 = 0xE11AD6B0

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon

greaterThan(QT_MAJOR_VERSION, 4)   { # FOR QT5

#    CONFIG += widgets               # QWidgets
#    CONFIG += quick                # QtQuick
    QT += qml
    QT += quick
    QT += widgets
    QT += 3dquick
    QT += sql

} else           {                     # FOR QT4 AND OTHER VERSIONS MEEGO MAEMO

    CONFIG += qdeclarative-boostable    # QtQuick 1 for Meego
    CONFIG += qt3d                      # QtQuick 3D
    CONFIG += quick                  # QtQuick 3D
    CONFIG += declarative opengl        # OpenGl et QtQuick 1
}
# Add dependency to Symbian components
# CONFIG += qt-components

HEADERS += QmlViewManager.h \
    ListModel.h \
    ListItem.h \
    QmlContentExposerInterface.h

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    QmlViewManager.cpp \
    ListModel.cpp

# Include Room Sources
include(Room/Room.pri)
# Include Services Sources
include(Services/Services.pri)
# Include Plugins Sources
include(Plugins/Plugins.pri)

# Please do not modify the following two lines. Required for deployment.
#include(qmlapplicationviewer/qmlapplicationviewer.pri)
#qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    splashscreen.png \
    icon.png \
    bar-descriptor.xml \
    qml/TepeeCamera.qml \
    qml/Widget.qml \
    qml/RoomModel.qml \
    qml/Room.qml \
    qml/MenuTop.qml \
    qml/MenuRight.qml \
    qml/MenuLeft.qml \
    qml/MenuCenter.qml \
    qml/MainRoom.qml \
    qml/qmldir \
    qml/main.qml

qnx {
    QMAKE_LFLAGS += '-Wl,-rpath,\'./app/native/lib\''

    PACKAGE_ARGS = \
        $${PWD}/bar-descriptor.xml $$TARGET \
        -e $${PWD}/icon.png res/icon.png \
        -e $$[QT_INSTALL_LIBS]/libQtCore.so.5 lib/libQtCore.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtGui.so.5 lib/libQtGui.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtOpenGL.so.5 lib/libQtOpenGL.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtNetwork.so.5 lib/libQtNetwork.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtWidgets.so.5 lib/libQtWidgets.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtQuick.so.5 lib/libQtQuick.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtQml.so.5 lib/libQtQml.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtSql.so.5 lib/libQtSql.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt3DQuick.so.5 lib/libQt3DQuick.so.5  \
        -e $$[QT_INSTALL_LIBS]/libQt3D.so.5 lib/libQt3D.so.5   \
        -e $$[QT_INSTALL_LIBS]/libQtV8.so.5 lib/libQtV8.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQtXmlPatterns.so.5 lib/libQtXmlPatterns.so.5 \
        -e $$[QT_INSTALL_PLUGINS]/platforms/libqnx.so plugins/platforms/libqnx.so \
        -e qml qml \
        -e $$[QT_INSTALL_IMPORTS]/ imports/

    package.target = $${TARGET}.bar
    package.depends = $$TARGET
    package.commands = blackberry-nativepackager \
        -package $${TARGET}.bar \
        -devMode -debugToken $$(DEBUG_TOKEN) \
        $${PACKAGE_ARGS}

    QMAKE_EXTRA_TARGETS += package

    OTHER_FILES += qnx/bar-descriptor.xml
}


