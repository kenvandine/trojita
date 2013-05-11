#include <QQuickView>
#include <QQmlContext>
#include <QQmlComponent>
#include <QApplication>
#include "QmlSupport/ModelGlue/ImapAccess.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQuickView view;
    ImapAccess imapAccess;

    view.rootContext()->setContextProperty("imapAccess",&imapAccess);
    view.setSource(QUrl("emailclient.qml"));
    view.show();
    return app.exec();
}
