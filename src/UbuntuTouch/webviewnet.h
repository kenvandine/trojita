#ifndef WEBVIEWREPLY_H
#define WEBVIEWREPLY_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QUrl>
#include "../Imap/Network/MsgPartNetAccessManager.h"
#include "../Imap/Network/MsgPartNetworkReply.h"
#include <QNetworkRequest>
#include <QNetworkAccessManager>

namespace UbuntuTouch
{

/*class WebViewNetReply : public QNetworkReply
{
    Q_OBJECT
    explicit WebViewNetReply(QObject *parent = 0);
};*/

class WebViewNetManager : public QObject
{
    Q_OBJECT

public:
    explicit WebViewNetManager(QObject *parent = 0);
    Q_INVOKABLE void getMessageFromURL(QObject *webView, QUrl url);
    QObject *requestingWebView;

public slots:
    void getHtmlFromReply();

private:
    Imap::Network::MsgPartNetAccessManager *netAccess;
    QNetworkReply *netReply;
};

#endif // WEBVIEWREPLY_H

}
