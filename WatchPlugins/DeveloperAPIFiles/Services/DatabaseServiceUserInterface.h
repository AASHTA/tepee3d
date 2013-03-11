#ifndef DATABASEUSER_H
#define DATABASEUSER_H

#include <QSqlRecord>
#include <QList>

namespace Services
{
// YOU NEED TO IMPLEMENT THIS INTERFACE IN ORDER TO RECEIVE SQL RESULTS
class   DatabaseServiceUserInterface
{
public :
    virtual void receiveResultFromSQLQuery(QList<QSqlRecord> result, int id) = 0;
// SIGNAL
    //void        executeSQLQuery(const QString& query, QObject *sender);

};
}

#endif // DATABASEUSER_H
