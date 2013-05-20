#ifndef IWEBREQUESTDISPATCHER_H
#define IWEBREQUESTDISPATCHER_H

class IWebRequestDispatcher
{
public :
    virtual int     getMajorIDRequestHandled()  const = 0;
    virtual void    receiveResultFromHttpRequest(QNetworkReply * reply,int id, void *data) = 0;

};

#endif // IWEBREQUESTDISPATCHER_H
