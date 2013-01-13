#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QList>
#include <QHash>
#include <QByteArray>
#include "ListItem.h"

class ListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ListModel(ListItem *prototype, QObject *parent = 0);
    ~ListModel();

    // REIMPLEMENTED METHODS
    int         rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant    data(const QModelIndex &index, int role) const;
    QModelIndex indexFromItem(ListItem *item) const;


    void        appendRow(ListItem *item);
    void        appendRows(QList<ListItem *> &items);
    void        insertRow(int row, ListItem *item);
    QHash<int, QByteArray>        roleNames() const;


    bool        removeRow(int row, const QModelIndex &parent = QModelIndex());
    bool        removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
    void        clear();

    int         getRowFromItem(ListItem *item) const;
    ListItem*   find(int itemId) const;
    QList<ListItem *>   toList() const;

protected:
    ListItem *prototype;
    QList<ListItem *> items;

private slots :
    void        updateItem();

};

#endif // LISTMODEL_H
