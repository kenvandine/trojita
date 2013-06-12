#include "webviewnet.h"

namespace UbuntuTouch {

/*WebViewNetReply::WebViewNetReply(QObject *parent) :
    QObject(parent)
{
}*/

WebViewNetManager::WebViewNetManager(QObject *parent) :
    QObject(parent)
{
}

void WebViewNetManager::getMessageFromURL(QObject *webView, QUrl url)
{
    //netReply = new WebViewNetReply(this);
    netAccess = new Imap::Network::MsgPartNetAccessManager(this);
    qDebug() << QNetworkAccessManager::GetOperation;
    netReply = netAccess->createRequest(QNetworkAccessManager::GetOperation,QNetworkRequest(url));
    connect(netReply,SIGNAL(finished()),this,SLOT(getHtmlFromReply()));
}

void WebViewNetManager::getHtmlFromReply()
{
    qDebug() << "Here";
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QByteArray data = reply->readAll();
    qDebug() << data.toInt();
    qDebug() << QString(data);
    //requestingWebView->setProperty("html",QString(netReply->readAll()));
}

}
