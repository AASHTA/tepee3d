#include "SubListedListModel.h"

/*!
 * \class Models::SubListedListModel
 * \code
 * #include <SubListedListModel.h>
 * \endcode
 * \brief The Models::SubListedListModel class provides an easy way to create C++ n-depth models
 * and expose them for Qml. This is useful in cases where you need to retrieve a sub model from
 * a given element in a model.
 *
 * \inmodule Tepee3D
 *
 * \sa Models::ListModel
 */

Models::SubListedListModel::SubListedListModel(Models::SubListedListItem *prototype, QObject *parent) : Models::ListModel(prototype, parent)
{
}

/*!
 * Returns the model contained by row Item identified by id.
 */
QObject*        Models::SubListedListModel::subModelFromId(int id)
{
    Models::SubListedListItem* item = (Models::SubListedListItem *)this->find(id);
    if (item != NULL)
        return item->submodel();
    return NULL;
}