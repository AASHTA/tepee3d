#include "WebServiceManager.h"
// DEBUG
#include <QDebug>

/*!
 * \class
 *
 * \brief WebServiceManager::WebServiceManager is a Web Service Library.
 *
 * WebServiceManager::WebServiceManager is a Web Service Library. It offers users to possiblity to make PUT POST DELETE GET Http requests
 * by implementing the Services::WebServiceUserInterface interface and subscribing to the service through the Services::ServicesManager.
 *
 * \sa Services::WebServiceUserInterface
 * \sa Services::ServicesManager
 */

/*!
 * \class Services::WebServiceUserInterface
 *
 * \code
 * #include <WebServiceUserInterface.h>
 * \endcode
 *
 * \brief Interface subscribers have to implement in order to properly handle and use this service.
 */

/*!
 * \fn void Services::WebServiceUserInterface::receiveResultFromHttpRequest(QNetworkReply *reply)
 *
 * Receives the \a reply of the last executed request.
 */

/*!
 * \fn void Services::WebServiceUserInterface::executeHttpGetRequest(const QNetworkRequest& request)
 *
 * Performs a GET Http \a request.
 */

/*!
 * \fn void Services::WebServiceUserInterface::executeHttpDeleteRequest(const QNetworkRequest& request)
 *
 * Performs a DELETE Http \a request.
 */

/*!
 * \fn void Services::WebServiceUserInterface::executeHttpPutRequest(const QNetworkRequest& request, QHttpMultiPart* multiPart)
 *
 * Performs a PUT Http \a request. If \a multiPart is not NULL its data will be transmitted with the request.
 */

/*!
 * \fn void Services::WebServiceUserInterface::executeHttpPostRequest(const QNetworkRequest& request, QHttpMultiPart* multiPart)
 *
 * Performs a POST Http \a request. If \a multiPart is not NULL its data will be transmitted with the request.
 */


/*!
 * Constructs a WebServiceManager instance.
 */
WebServiceManager::WebServiceManager() : QObject()
{
    this->httpMethods[Services::WebServiceUserInterface::Get] = &WebServiceManager::httpGet;
    this->httpMethods[Services::WebServiceUserInterface::Delete] = &WebServiceManager::httpDelete;
    this->httpMethods[Services::WebServiceUserInterface::Post] = &WebServiceManager::httpPost;
    this->httpMethods[Services::WebServiceUserInterface::Put] = &WebServiceManager::httpPut;
}

/*!
 * Returns a singleton instance of QNetworkAccessManager to ensure all requests will go through the same instance.
 */
QNetworkAccessManager*  WebServiceManager::getInstance()
{
    if (instance == NULL)
        instance = new QNetworkAccessManager();
    return instance;
}


/*!
 * Performs a GET Http \a request, the reply will be transmitted to \a sender.
 */

// NETWORK REPLYREPEATER HAS TO BE DELETED IN PLUGIN
// QNETWORKREPLY HAS TO BE DELETED USING DELETELATER
void  WebServiceManager::httpGet(QNetworkRequest &request, QHttpMultiPart*, QObject *sender)
{
    qDebug() << "Executing HttpGetRequest";
    NetworkReplyRepeater *repeater = new NetworkReplyRepeater(sender);
    QNetworkReply *reply = this->getInstance()->get(request);
    QObject::connect(reply, SIGNAL(finished()), repeater, SLOT(receiveNetworkReply()));
}

/*!
 * Performs a DELETE Http \a request, the reply will be transmitted to \a sender.
 */
void  WebServiceManager::httpDelete(QNetworkRequest &request, QHttpMultiPart*, QObject *sender)
{
    qDebug() << "Executing HttpGetDelete";
    NetworkReplyRepeater *repeater = new NetworkReplyRepeater(sender);
    QNetworkReply*reply = this->getInstance()->deleteResource(request);
    QObject::connect(reply, SIGNAL(finished()), repeater, SLOT(receiveNetworkReply()));
}

/*!
 * Performs a POST Http \a request, the reply will be transmitted to \a sender. If \a multiPart is not NULL
 * its data will be transmitted with the request.
 */
void  WebServiceManager::httpPost(QNetworkRequest &request, QHttpMultiPart *multiPart, QObject *sender)
{
    qDebug() << "Executing HttpGetPost";
    NetworkReplyRepeater *repeater = new NetworkReplyRepeater(sender);
    QNetworkReply *reply = this->getInstance()->post(request, multiPart);
    QObject::connect(reply, SIGNAL(finished()), repeater, SLOT(receiveNetworkReply()));
}

/*!
 * Performs a PUT Http \a request, the reply will be transmitted to \a sender. If \a multiPart is not NULL
 * its data will be transmitted with the request.
 */
void  WebServiceManager::httpPut(QNetworkRequest &request, QHttpMultiPart *multiPart, QObject *sender)
{
    qDebug() << "Executing HttpGetPut";
    NetworkReplyRepeater *repeater = new NetworkReplyRepeater(sender);
    QNetworkReply *reply = this->getInstance()->put(request, multiPart);
    QObject::connect(reply, SIGNAL(finished()), repeater, SLOT(receiveNetworkReply()));
}

bool  WebServiceManager::connectServiceToUser(QObject *user)
{
    qDebug() << "Connecting user to WebServices";
    // HTTP
    if (dynamic_cast<Services::WebServiceUserInterface*>(user) != NULL)
        return QObject::connect(user, SIGNAL(executeHttpRequest(const QNetworkRequest&, int, QHttpMultiPart*, QObject*)),
                         this, SLOT(executeHttpRequest(QNetworkRequest, int, QHttpMultiPart*, QObject*)));
    qWarning() << "Object does not implement WebServiceUserInterface";
    return false;
}

bool  WebServiceManager::disconnectServiceFromUser(QObject *user)
{
    // HTTP
    if (dynamic_cast<Services::WebServiceUserInterface*>(user) != NULL)
        return QObject::connect(user, SIGNAL(executeHttpRequest(const QNetworkRequest&, int, QHttpMultiPart*, QObject*)),
                         this, SLOT(executeHttpRequest(QNetworkRequest, int, QHttpMultiPart*, QObject*)));
    qWarning() << "Object does not implement WebServiceUserInterface";
    return false;
}


QJsonObject*    WebServiceManager::QJsonFromReply(QNetworkReply *reply)
{
    return new QJsonObject(QJsonDocument::fromJson(reply->readAll()).object());
}

void            WebServiceManager::initLibraryConnection(QObject *parent)
{
//    QObject::connect(parent, SIGNAL(executeHttpRequest(const QNetworkRequest &, int, QHttpMultiPart*, QObject*)),
//                     this, SLOT(executeHttpRequest(QNetworkRequest, int, QHttpMultiPart*, QObject*)));
}

void            WebServiceManager::executeHttpRequest(QNetworkRequest request, int requestType, QHttpMultiPart *multiPart, QObject *sender)
{
    qDebug() << "Executing HttpRequest";
    (this->*this->httpMethods[requestType])(request, multiPart, sender);
}

QObject*        WebServiceManager::getLibraryQObject()
{
    return this;
}


QNetworkAccessManager* WebServiceManager::instance = NULL;
