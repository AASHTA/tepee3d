#ifndef DATABASETHREAD_H
#define DATABASETHREAD_H

#include <QThread>
#include "ServiceInterface.h"
#include "managebdd.h"
#include "DatabaseServiceUserInterface.h"


class DatabaseThread : public QThread, Services::ServiceInterface
{
    Q_OBJECT
    Q_INTERFACES(Services::ServiceInterface)
    Q_PLUGIN_METADATA(IID "com.tepee3d.Services.databaseservice")

public:
    DatabaseThread();
    ~DatabaseThread();
    void        run();
    void        stop();

    void        initLibraryConnection(QObject *parent);
    QObject*    getLibraryQObject();

private slots:
    void        transmitSQLResult(const QList<QSqlRecord>& result, QObject *receiver);
signals:
    void        executeSQLQuery(const QString& query, QObject *sender);
};

#endif // DATABASETHREAD_H
