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

Page {
    signal mailboxSelected(string mailbox)
    property int nestingDepth: 0
    property string viewTitle: isNestedSomewhere() ? currentMailbox : imapAccess.server
    property string currentMailbox
    property string currentMailboxLong
    property variant model

    function openParentMailbox() {
        moveListViewRight.start()
        model.setRootOneLevelUp()
        --nestingDepth
        currentMailbox = imapAccess.mailboxListShortMailboxName()
        currentMailboxLong = imapAccess.mailboxListMailboxName()
    }

    function isNestedSomewhere() {
        return nestingDepth > 0
    }

    id: root
    //tools: commonTools

    Component {
        id: mailboxItemDelegate

        Item {
            width: units.gu(400)
            height: units.gu(5)
            anchors.margins: units.gu(1)

            Item {
                anchors {
                    top: parent.top; bottom: parent.bottom; left: parent.left;
                    //right: moreIndicator.visible ? moreIndicator.left : parent.right
                    right: parent.right
                    leftMargin: 6
                    rightMargin: 16
                }

                MouseArea {
                    width: units.gu(50)
                    height: units.gu(5)
                    onClicked: {
                        view.positionViewAtIndex(model.index, ListView.Visible);
                        view.currentIndex = model.index
                        if (mailboxIsSelectable) {
                            currentMailbox = shortMailboxName
                            currentMailboxLong = mailboxName
                            mailboxSelected(mailboxName)
                        }
                    }
                }
                Label {
                    id: titleText
                    text: shortMailboxName
                }
                Label {
                    id: messageCountsText
                    anchors.top: titleText.bottom
                    visible: mailboxIsSelectable && totalMessageCount !== undefined
                    text: totalMessageCount === 0 ?
                              "No messages" :
                              (totalMessageCount + " total, " + unreadMessageCount + " unread")
                }
                Label {
                    anchors.top: titleText.bottom
                    visible: mailboxIsSelectable && totalMessageCount === undefined
                    text: qsTr("Loading...")
                }
            }

            Button {
                id: moreIndicator
                visible: mailboxHasChildMailboxes
                anchors {verticalCenter: parent.verticalCenter; right: parent.right}

                onClicked: {
                    view.positionViewAtIndex(model.index, ListView.Visible);
                    currentMailbox = shortMailboxName
                    currentMailboxLong = mailboxName
                    view.currentIndex = model.index
                    moveListViewLeft.start()
                    root.model.setRootItemByOffset(model.index)
                    ++nestingDepth
                }
            }
        }
    }

    Item {
        id: contentView
        anchors.fill: parent

        ListView {
            id: view
            anchors.fill: parent
            focus: true
            delegate: mailboxItemDelegate

            model: root.model
        }

        /*ScrollDecorator {
            flickableItem: view
        }*/

        Label {
            id: header
            text: viewTitle
            fontSize: "large"
            anchors {left: parent.left; right: parent.right; top: parent.top}
        }
    }

    // FIXME: can we use shaders for these?
    SequentialAnimation {
        id: moveListViewLeft
        property int oneStepDuration
        ScriptAction { script: contentView.anchors.fill = undefined }
        PropertyAnimation { target: contentView; properties: "x"; to: -contentView.width; duration: moveListViewLeft.oneStepDuration }
        PropertyAction { target: contentView; property: "x"; value: contentView.width }
        PropertyAnimation { target: contentView; properties: "x"; to: 0; duration: moveListViewLeft.oneStepDuration }
        ScriptAction { script: contentView.anchors.fill = contentView.parent }
    }

    SequentialAnimation {
        id: moveListViewRight
        property alias oneStepDuration: moveListViewLeft.oneStepDuration
        ScriptAction { script: contentView.anchors.fill = undefined }
        PropertyAnimation { target: contentView; properties: "x"; to: contentView.width; duration: moveListViewRight.oneStepDuration }
        PropertyAction { target: contentView; property: "x"; value: -contentView.width }
        PropertyAnimation { target: contentView; properties: "x"; to: 0; duration: moveListViewRight.oneStepDuration }
        ScriptAction { script: contentView.anchors.fill = contentView.parent }
    }
}
