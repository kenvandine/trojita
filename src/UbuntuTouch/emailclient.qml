import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import "qml/emailclient"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "emailclient"
    id: app
    property real defaultMargin: units.gu(1)
    property bool networkOffline: true
    property Item fwdOnePage: null
    property bool messageVisible: false

    function showConnectionError(message) {
        passwordDialog.close()
        connectionErrorBanner.text = message
        connectionErrorBanner.parent = pageStack.currentPage
        connectionErrorBanner.show()
        networkOffline = true
    }

    function showImapAlert(message) {
        alertBanner.text = message
        alertBanner.parent = pageStack.currentPage
        alertBanner.show()
    }

    function requestingPassword() {
        if(!messageVisible) PopupUtils.open(passwordDialog,app)
    }

    function authAttemptFailed(message) {
        messageVisible = true;
        PopupUtils.open(messageDialog,app,{"text": message, "messageMode": "password"});
    }

    function connectModels() {
        imapAccess.imapModel.connectionError.connect(showConnectionError)
        imapAccess.imapModel.alertReceived.connect(showImapAlert)
        imapAccess.imapModel.authRequested.connect(requestingPassword)
        imapAccess.imapModel.authAttemptFailed.connect(authAttemptFailed)
        imapAccess.imapModel.networkPolicyOffline.connect(function() {networkOffline = true})
        imapAccess.imapModel.networkPolicyOnline.connect(function() {networkOffline = false})
        imapAccess.imapModel.networkPolicyExpensive.connect(function() {networkOffline = false})
        imapAccess.checkSslPolicy.connect(function() {PopupUtils.open(sslSheet)})
    }

    function goBack() {
        if (pageStack.currentPage === mailboxListPage && mailboxListPage.isNestedSomewhere()) {
            mailboxListPage.openParentMailbox()
        } else {
            pageStack.pop()
        }
    }

    function backButtonEnabled() {
        return (pageStack.currentPage === mailboxListPage && mailboxListPage.isNestedSomewhere()) || pageStack.depth > 1
    }

    function showHome() {
        tabs.selectedTabIndex = 0;
        mailboxListPage.nestingDepth = 0
        mailboxListPage.currentMailbox = ""
        mailboxListPage.currentMailboxLong = ""
        if (mailboxListPage.model)
            mailboxListPage.model.setOriginalRoot()
    }

    Component.onCompleted: {
        imapAccess.sslMode = imapAccess.sslMode
        connectModels()
    }

    width: units.gu(150)
    height: units.gu(75)

    Action {
        id: settingsAction
        text: "Settings"
        onTriggered: {
             PopupUtils.open(serverSettings)
         }
     }

     Action {
        id: syncAction
        text: "Sync"
        onTriggered: {
            showHome();
        }
    }

    actions: [settingsAction,syncAction]

    Tabs {
        id: tabs
        anchors.fill: parent

        Tab {
            id: mailboxTab
            title: "Mailboxes"
            page: MailboxListPage {
                id: mailboxListPage
                model: imapAccess.mailboxModel ? imapAccess.mailboxModel : null
                tools: ToolbarItems {
                    ToolbarButton {
                        action: settingsAction
                    }
                    ToolbarButton {
                        action: syncAction
                    }
                }

                onMailboxSelected: {
                    imapAccess.msgListModel.setMailbox(mailbox);
                    messageListPage.scrollToBottom();
                    tabs.selectedTabIndex = 1;
                }

                property bool indexValid: model ? model.itemsValid : true
                onIndexValidChanged: if (!indexValid) app.showHome()
            }
        }

        Tab {
            id: inboxTab
            title: "Inbox"
            page: Page {
                PageStack {
                    id: pageStack
                    Component.onCompleted: {
                        push(messageListPage)
                    }
                }

                MessageListPage {
                    id: messageListPage
                    model: imapAccess.msgListModel ? imapAccess.msgListModel : undefined

                    onMessageSelected: {
                        imapAccess.openMessage(mailboxListPage.currentMailboxLong, uid)
                        pageStack.push(Qt.resolvedUrl("qml/emailclient/OneMessagePage.qml"),
                                       {
                                           mailbox: mailboxListPage.currentMailboxLong,
                                           url: imapAccess.oneMessageModel.mainPartUrl.toString()
                                       })

                        //console.log(imapAccess.oneMessageModel.mainPartUrl.toString());
                    }
                }
            }
        }
    }

    Component {
        id: serverSettings
        ComposerSheet {
            contentsHeight: app.height
            contentsWidth: app.width
            title: "Server Settings"
            ImapSettings {
                id: imapSettings
            }

            Component.onCompleted: {
                imapSettings.imapServer = imapAccess.server
                if (imapAccess.port > 0)
                    imapSettings.imapPort = imapAccess.port
                imapSettings.imapUserName = imapAccess.username
                // That's right, we do not load the password
                if (imapAccess.sslMode == "StartTLS")
                    imapSettings.imapSslModeIndex = 2
                else if (imapAccess.sslMode == "SSL")
                    imapSettings.imapSslModeIndex = 1
                else
                    imapSettings.imapSslModeIndex = 0
            }

            onConfirmClicked: {
                if (imapSettings.imapServer != imapAccess.server)
                    imapAccess.forgetSslCertificate()
                imapAccess.server = imapSettings.imapServer
                imapAccess.port = imapSettings.imapPort
                imapAccess.username = imapSettings.imapUserName
                if (imapSettings.imapPassword.length)
                    imapAccess.password = imapSettings.imapPassword
                imapAccess.sslMode = imapSettings.imapSslMode
                connectModels()
            }
        }
    }

    Component {
        id: sslSheet
        SslSheet {
            titleText: imapAccess.sslInfoTitle
            messageText: imapAccess.sslInfoMessage+imapAccess.sslInfoMessage
            onConfirmClicked: imapAccess.setSslPolicy(true)
            onCancelClicked: imapAccess.setSslPolicy(false)
        }
    }

    Component {
        id: passwordDialog
        PasswordInputSheet {
        }
    }

    Component {
        id: messageDialog
        Dialog {
            id: messageDialogue
            property string messageMode: ""
            Button {
                text: i18n.tr("Close")
                onClicked: {
                    messageVisible = false;
                    console.log(messageDialogue.messageMode);
                    if(messageDialogue.messageMode == "password") { PopupUtils.open(passwordDialog,app); }
                    messageDialogue.messageMode = "";
                    PopupUtils.close(messageDialogue);
                }
            }
        }
    }
}
