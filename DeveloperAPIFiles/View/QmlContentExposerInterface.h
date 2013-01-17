#ifndef QMLCONTENTEXPOSERINTERFACE_H
#define QMLCONTENTEXPOSERINTERFACE_H

#include <QQmlContext>

class   QmlContentExposerInterface
{
public :
    virtual void    exposeContentToQml(QQmlContext *context) = 0;
};


#endif // QMLCONTENTEXPOSERINTERFACE_H
