/****************************************************************************
**
** Copyright (C) Paul Lemire, Tepee3DTeam and/or its subsidiary(-ies).
** Contact: paul.lemire@epitech.eu
** Contact: tepee3d_2014@labeip.epitech.eu
**
** This file is part of the Tepee3D project
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
****************************************************************************/

#include "QmlViewProperties.h"
#include <QDebug>


/*!
 * \namespace View
 *
 * \brief The View namespace contains all the classes responsible
 * for the Qml view management or that interact between the view and
 * other modules such as Services or Plugins.
 *
 * \inmodule Tepee3D
 */

/*!
 * \class View::QmlContentExposerInterface
 * \code
 * #include <QmlContentExposerInterface.h>
 * \endcode
 * \brief Has to be implemented in order to expose QML content to the QML context.
 *
 * \inmodule Tepee3D
 */

/*!
 * \fn void View::QmlContentExposerInterface::exposeContentToQml(QQmlContext *context)
 *
 * Exposes QML content to the QML \a context.
 */

/*!
 * \class View::QmlViewProperties
 *
 * \code
 * #include <QmlViewProperties.h>
 * \endcode
 *
 * \brief The View::QmlViewProperties class hold the properties
 * of the Qml view.
 *
 * It is a singleton class that should only be used by the View::QmlViewManager
 * class. It contains the QQuickView responsible for showing the Qml content onscreen,
 * the Qml Engine and the Qml Context. More, this is where qml content is exposed to
 * the Qml Context to later be used directly from Qml files.
 *
 *
 * \inmodule Tepee3D
 */



View::QmlViewProperties* View::QmlViewProperties::instance = NULL;

/*!
 * Constructs a new View::QmlViewProperties instance with \a parent.
 */

View::QmlViewProperties::QmlViewProperties(QObject *parent) : QObject(parent)
{
    this->viewer = new QQuickView();                     //USED TO DISPLAY QML
    this->qmlEngine = this->viewer->engine();            //RETRIEVED FROM THE VIEWER USED TO INSTANCIATE AND INSERT NEW QML COMPONENTS FROM PLUGINS
    this->qmlContext = this->viewer->rootContext();      //USED TO SET PROPERTIES TO QML FOR MODELS
    QObject::connect((QObject*)this->qmlEngine, SIGNAL(quit()), this, SIGNAL(quit()));
}

/*!
 * Destroys a View::QmlViewProperties instance.
 */
View::QmlViewProperties::~QmlViewProperties()
{
    delete this->viewer;
}

/*!
 * Returns a singleton instance of the class, constructing the instance, with the optionnal \a parent parameter, if it hasn't before.
 */
View::QmlViewProperties* View::QmlViewProperties::getInstance(QObject *parent)
{
    if (View::QmlViewProperties::instance == NULL)
        View::QmlViewProperties::instance = new View::QmlViewProperties(parent);
    return View::QmlViewProperties::instance;
}

/*!
 * Exposes the \a exposer instance to the QML context if exposer implements the QmlContentExposerInterface
 * \sa QmlContentExposerInterface
 */
void    View::QmlViewProperties::exposeContentToQml(QObject *exposer)
{
    qDebug() << "Exposing Qml Content";
    View::QmlContentExposerInterface* viewInterface = NULL;
    if (View::QmlViewProperties::instance == NULL)
        return ;
    if ((viewInterface = qobject_cast<View::QmlContentExposerInterface *>(exposer)) != NULL)
        viewInterface->exposeContentToQml(View::QmlViewProperties::instance->qmlContext);
}

/*!
 * Sets \a sourceFile as the source of the QML viewer.
 */
void    View::QmlViewProperties::setViewerSource(const QUrl &sourceFile)
{
    this->viewer->setSource(sourceFile);
}

/*!
 * Shows the QML viewer.
 */
void    View::QmlViewProperties::showView()
{
//    this->viewer->show();
    this->viewer->showFullScreen();
}
