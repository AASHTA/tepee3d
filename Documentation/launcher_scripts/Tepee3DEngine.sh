#!/bin/sh
export LD_LIBRARY_PATH=`pwd`/Qt_Libraries
export QML_IMPORT_PATH=`pwd`/Qt_Libraries/qml
export QML2_IMPORT_PATH=`pwd`/Qt_Libraries/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=`pwd`/Qt_Libraries/platforms
`pwd`/Tepee3DEngine
