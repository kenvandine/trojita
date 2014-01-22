#include <QtQuick/QQuickView>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlComponent>
#include <QtQml/QQmlContext>
#include "QmlSupport/ModelGlue/ImapAccess.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    ImapAccess imapAccess;

    view.rootContext()->setContextProperty("imapAccess",&imapAccess);
    view.setSource(QUrl("qrc:///emailclient.qml"));
    view.show();
    return app.exec();
}
