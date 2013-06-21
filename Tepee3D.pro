TEMPLATE    = subdirs
SUBDIRS     =  RoomLibrary       \
               ServicesLibraries \
               Tepee3DCoreLibrary \
               Tepee3DEngine \
               Plugins

message($$QMAKESPEC)

# BUILD IS DONE ACCORD TO THE ORDER OF SUBDIRS
CONFIG += ordered

# DOC APPEARS ONLY FOR WINDOWS AND LINUX PLATFORMS

!android:!qnx {
SUBDIRS += UnitTests

OTHER_FILES += Documentation/config.qdocconf \
               Documentation/install.qdoc \
               Documentation/vm_instruction.qdoc \
               Documentation/how-to-plugins.qdoc \
               Documentation/all_classes.qdoc \
               Documentation/index.qdoc
}

android {
OTHER_FILES += android/AndroidManifest.xml
qml_folder.files += Tepee3DEngine/qml/
qml_folder.files += Tepee3DEngine/plugins_qml/
qml_folder.files += Tepee3DEngine/libraries/
qml_folder.files += Tepee3DEngine/databases/
qml_folder.files += Tepee3DEngine/DeveloperAPIFiles/
qml_folder.path = android/assets
INSTALLS += qml_folder
DEPLOYMENT += qml_folder
}




