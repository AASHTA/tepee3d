#include "AndroidPlatformInitializer.h"
#include <QDebug>

AndroidPlatformInitializer::AndroidPlatformInitializer() : IPlatformInitializer()
{
}

bool AndroidPlatformInitializer::initPlatform()
{
    // Copy files from assets to data dir

    if (QFile("assets:/qml/main.qml").exists())
    {
        qDebug() << "Copying Files Android";
        QDir assetDirectory("assets:/databases/");
        //QDir assetDirectory2("assets:/plugins_qml/");
        //QDir assetDirectory3("assets:/DeveloperAPIFiles/");

        // qml
        foreach (QString entry, assetDirectory.entryList(QDir::Files))
        {
            qDebug() << "Copying " << AndroidPlatformInitializer::getDataDirectory().absolutePath() + "/databases/"  + entry;
            QFile(entry).copy(AndroidPlatformInitializer::getDataDirectory().absolutePath() + "/databases/"  + entry);
        }
//        // plugins_qml
//        foreach (QString entry, assetDirectory2.entryList())
//        {
//            qDebug() << "entry 2" << entry;
//        }
//        // databases
//        foreach (QString entry, assetDirectory3.entryList())
//        {
//            qDebug() << "entry 3" << entry;
//        }
    }
    qDebug() << "Copying Files Done";
    return true;
}

QDir AndroidPlatformInitializer::getWidgetSharedLibrariesDirectory() const
{
    return QDir(ANDROID_LIB_DIR);
}

QDir AndroidPlatformInitializer::getServicesSharedLibrariesDirectory() const
{
    return QDir(ANDROID_LIB_DIR);
}

QDir AndroidPlatformInitializer::getRoomSharedLibraryDirectory() const
{
    return QDir(ANDROID_LIB_DIR);
}

QDir AndroidPlatformInitializer::getDataDirectory() const
{
    return QDir(ANDROID_DATA_DIR);
}

QString AndroidPlatformInitializer::getPlatformName() const
{
    return ANDROID_PLATFORM;
}
