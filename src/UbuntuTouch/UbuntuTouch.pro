#-------------------------------------------------
#
# Project created by QtCreator 2013-03-10T23:31:06
#
#-------------------------------------------------

mainQml.path = $${OUT_PWD}/
mainQml.files = emailclient.qml
qmlFolder.path = $${OUT_PWD}/qml
qmlFolder.files = qml/*
resourcesFolder.path = $${OUT_PWD}/resources
resourcesFolder.files = resources/*
#destination folder in the build directory and the install directory
INSTALLS += qmlFolder mainQml resourcesFolder

SOURCES += main.cpp \
    webviewnet.cpp
TARGET = trojita-tp

INCLUDEPATH += ../
DEPENDPATH += ../

trojita_libs = ModelGlue
myprefix = ../QmlSupport/
include(../linking.pri)

trojita_libs = Imap Streams Common
myprefix = ../
include(../linking.pri)

include(../../configh.pri)
include(../Streams/ZlibLinking.pri)

QT += network sql webkit core gui qml quick

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

RESOURCES +=

OTHER_FILES += \
    emailclient.qml \
    qml/emailclient/ToggleableToolIcon.qml \
    qml/emailclient/SslSheet.qml \
    qml/emailclient/PercentageSectionScroller.qml \
    qml/emailclient/PasswordInputSheet.qml \
    qml/emailclient/PageHeader.qml \
    qml/emailclient/OneMessagePage.qml \
    qml/emailclient/NetworkPolicyButton.qml \
    qml/emailclient/MessageListPage.qml \
    qml/emailclient/MainPage.qml \
    qml/emailclient/MailboxListPage.qml \
    qml/emailclient/ImapSettings.qml \
    qml/emailclient/BackButton.qml \
    qml/emailclient/AddressWidget.qml \
    qml/emailclient/Utils.js

HEADERS += \
    webviewnet.h
