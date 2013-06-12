/* Copyright (C) 2006 - 2013 Jan Kundrát <jkt@flaska.net>

   This file is part of the Trojita Qt IMAP e-mail client,
   http://trojita.flaska.net/

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3 or any later version
   accepted by the membership of KDE e.V. (or its successor approved
   by the membership of KDE e.V.), which shall act as a proxy
   defined in Section 14 of version 3 of the license.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

Flickable {
    ListModel {
        id: encryptionMethodModel
        ListElement {
            name: "No Encryption"
            port: 143
        }
        ListElement {
            name: "SSL"
            port: 993
        }
        ListElement {
            name: "StartTLS"
            port: 143
        }
    }

    Component {
        id: encryptionMethodSelector
        Popover {
            Column {
                height: encryptionMethodList.childrenRect.height + header.height
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Header {
                    id: header
                    text: i18n.tr("Select currency")
                }

                ListView {
                    id: encryptionMethodList
                    clip: true
                    model: encryptionMethodModel
                    width: parent.width
                    height: childrenRect.height

                    delegate: Standard {
                        text: name
                        onClicked: {
                            imapSslMode = name
                            imapSslModeIndex = index
                            imapPortInput.text = port
                            encryptionMethodBtn.text = name
                            hide()
                        }
                    }
                }
            }
        }
    }

    property alias imapServer: imapServerInput.text
    property alias imapPort: imapPortInput.text
    property alias imapUserName: imapUserNameInput.text
    property alias imapPassword: imapPasswordInput.text
    property string imapSslMode: "No"
    property int imapSslModeIndex: 0

    id: flickable
    anchors.fill: parent
    flickableDirection: Flickable.VerticalFlick

    Column {
        id: col
        spacing: 10
        anchors.fill: parent
        anchors.margins: units.gu(1)

        Label {
            text: i18n.tr("Name")
        }
        TextField {
            id: realName
            anchors {left: col.left; right: col.right;}
        }

        Label {
            text: i18n.tr("E-mail address")
        }
        TextField {
            id: email
            anchors {left: col.left; right: col.right;}
            //inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
        }

        Label {
            text: i18n.tr("Username")
        }
        TextField {
            id: imapUserNameInput
            anchors {left: col.left; right: col.right;}
            //inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
        }

        Label {
            text: i18n.tr("Password")
        }
        TextField {
            id: imapPasswordInput
            anchors {left: parent.left; right: parent.right;}
            //inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            echoMode: TextInput.Password
        }

        Label {
            text: i18n.tr("Server address")
        }
        TextField {
            id: imapServerInput
            anchors {left: col.left; right: col.right;}
            //inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
        }

        Button {
            id: encryptionMethodBtn
            anchors {left: col.left; right: col.right;}
            text: encryptionMethodModel.get(imapSslModeIndex).name

            onClicked: {
                PopupUtils.open(encryptionMethodSelector,encryptionMethodBtn)
            }
        }

        Label {
            text: i18n.tr("Port")
        }
        TextField {
            id: imapPortInput
            text: "143"
            anchors {left: col.left; right: col.right;}
            //inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 1; top: 65535 }
        }
    }
}
