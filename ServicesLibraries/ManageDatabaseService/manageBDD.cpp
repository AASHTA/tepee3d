#include "manageBDD.h"
// DEBUG
#include <QDebug>


/*!
 * \class ManageBDD
 * \code
 * #include <manageBDD.h>
 * \endcode
 * \brief The ManageBDD class, offers the ability to execute queries on
 * the SQLite database.
 *
 * The Service should hava a single instance of this class and preferably living in
 * a thread so that a single database connection can be used throughout the entire
 * time the application is used.
 *
 * \inmodule Tepee3D
 */


/*!
 * Constructs a new ManageBDD instance, opens a database connection
 * and fill it for the first use if necessary.
 */
ManageBDD::ManageBDD() : QObject()
{
    this->dataBase = QSqlDatabase::addDatabase("QSQLITE");
    qDebug() << "DB CONNECTION VALID ? " << this->dataBase.isValid();
    this->applicationPath = QCoreApplication::applicationDirPath();
    this->localDBName = "";
    this->databasePath = "";
    this->previousDbName = "";
}

/*!
 * Destroys a ManageBDD instance, close the database connection if opened.
 */
ManageBDD::~ManageBDD()
{
    if (this->dataBase.isOpen())
        this->dataBase.close();
    this->dataBase.removeDatabase(this->dataBase.connectionName());
}

/*!
 * Opens a database connection to the database specified by \a dbName.
 * If the connection is successfully opened, returns true, false otherwise.
 */
bool ManageBDD::openDatabase(const QString& dbName)
{
    // GET DB PATH FROM HASH OF SAVED DB PATHS
    this->localDBName = this->nameToPathHash[dbName];

    // IF DATABASE HAS NOT BEEN OPENED YET
    if (this->localDBName.isNull() || this->localDBName.isEmpty())
    {
#ifdef Q_OS_QNX
        // ON QNX, DATABASE HAVE TO BE COPIED TO THE data DIRECTORY
        // IN ORDER TO BE USED
        if (this->databasePath.isEmpty())
        {
            QDir dbDir(this->applicationPath);
            dbDir.cdUp();
            dbDir.cdUp();
            dbDir.cd("data");
            this->databasePath = dbDir.absolutePath();
        }
        QFile dbFile(this->databasePath + "/" + dbName);
        qDebug() << dbFile.fileName();
        if (!dbFile.exists())
        {
            qDebug() << "File doesn't exist";
            QFile dbTemplate(this->applicationPath + "/databases/" + dbName);
            qDebug() << "Trying to copy " << dbTemplate.fileName();
            if (dbTemplate.exists())
               dbTemplate.copy(dbFile.fileName());
        }
        else
            qDebug() << "File already exists";
        // OPENED DB PATH IS SAVED IN HASH
        this->nameToPathHash[dbName] = dbFile.fileName();
        this->localDBName = this->nameToPathHash[dbName];
#endif

#ifdef Q_OS_WIN32
        // ON WINDOWS THE SQL DATABASES MUST BE IN THE APPDATA DIRECTORY
        // OTHERWISE THE PROGRAM AS TO BE RUN AS ADMINISTRATOR TO SAVE IN THE BDD


#endif

#ifdef Q_OS_LINUX
        // ON LINUX DATABASES CAN BE READ DIRECTLY FROM THE databases DIRECTORY
        // OF THE APPLICATION
        if (this->databasePath.isEmpty())
            this->databasePath = QDir::currentPath() + "/databases/";
        this->nameToPathHash[dbName] = this->databasePath + dbName;
        this->localDBName =  this->nameToPathHash[dbName];
#endif
    }

    qDebug() << localDBName;
    this->dataBase.setHostName("localhost");
    this->dataBase.setDatabaseName(localDBName);

    // THE DATABASE IS NOW CONTAINED IN THE TEPEE3DENGINE
    // THIS ALLOWS US TO PROVIDE A DATABASE SCHEMA WITHOUT HAVING TO
    // CREATE IT ON THE FIRST BOOT
    qDebug() << "Trying to open db";
    bool value = this->dataBase.open();
    qDebug() << "Database open " << value;
    return value;
}

/*!
 * Executes \a query on the database. The result will be transmitted to \a sender
 * along with the given \a id and \a data parameters.
 */
//execute a query in database and send the result by a signal
void ManageBDD::executeSQLQuery(const QString& query, QObject *sender, int id, const QString &dbName, void *data)
{
    QList<QSqlRecord> results;
    if (dbName != this->previousDbName)
    {
        qDebug() << "1";
        this->dataBase.close();
        qDebug() << "2";
        this->openDatabase(dbName);
        qDebug() << "3";
        this->previousDbName = dbName;
        qDebug() << "4";
        QSqlQuery sqlQuery(this->dataBase);
        qDebug() << "5";
        sqlQuery.exec("PRAGMA synchronous=OFF;");
        qDebug() << "6";
    }
    if (this->dataBase.isOpen())
    {
        qDebug() << "Received query : {" << query << "}";
        QSqlQuery sqlQuery(this->dataBase);
        sqlQuery.prepare(query);
        if (sqlQuery.exec())
            qDebug() << "Query Execution Succeeded";
        else
            qDebug() << "YOU SHOULD CHECK YOUR QUERY";
        results.push_back(sqlQuery.record());
        while (sqlQuery.next())
            results.push_back(sqlQuery.record());
    }
    emit resultFromSQLQuery(results, sender, id, data);
}

