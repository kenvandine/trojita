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
import Ubuntu.Components.Popups 0.1

Dialog {
    id: dialogue
    property alias authErrorMessage: authFailedMessage.text
    title: "Enter Password"

    Label {
        id: authFailureReason
        visible: false
    }
    TextField {
        id: password
        anchors {left: parent.left; right: parent.right;}
        echoMode: TextInput.Password
    }
    Label {
        id: authFailedMessage
        anchors { left: parent.left; right: parent.right; topMargin: 40; leftMargin: 16; rightMargin: 16 }
        wrapMode: Text.Wrap
    }

    Button {
        text: "Login"
        color: "green"
        onClicked: {
            imapAccess.imapModel.imapPassword = password.text;
            PopupUtils.close(dialogue);
        }
    }

    Button {
        text: "Cancel"
        color: "red"
        onClicked: {
            imapAccess.imapModel.imapPassword = undefined;
            PopupUtils.close(dialogue);
        }
    }
}
