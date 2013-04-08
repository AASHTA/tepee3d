#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QList>
#include <QHash>
#include <QByteArray>
#include "ListItem.h"

namespace Models
{

class ListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
    explicit ListModel(ListItem *prototype, QObject *parent = 0);
    ~ListModel();

    // REIMPLEMENTED METHODS
    int                     rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant                data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray>  roleNames() const;

    void                    appendRow(ListItem *item);
    void                    appendRows(QList<ListItem *> &items);
    void                    insertRow(int row, ListItem *item);
    ListItem*               takeRow(int row = -2, const QModelIndex &index = QModelIndex());
    QList<ListItem *>       takeRows(int row = -2, int count = -1, const QModelIndex &index = QModelIndex());
    bool                    removeRow(int row, const QModelIndex &index = QModelIndex());
    bool                    removeRows(int row, int count, const QModelIndex &index = QModelIndex());

    ListItem*               find(int itemId) const;
    int                     getRowFromItem(ListItem *item) const;
    QModelIndex             indexFromItem(ListItem *item) const;
    QList<ListItem *>       toList() const;

    Q_INVOKABLE QVariant    get(int index);
    Q_INVOKABLE int         rowIndexFromId(int id);
    Q_INVOKABLE void        clear();

protected:
    ListItem *prototype;
    QList<ListItem *> items;

private slots :
    void        updateItem();

signals :
    void        countChanged(int);

};

}

#endif // LISTMODEL_H
