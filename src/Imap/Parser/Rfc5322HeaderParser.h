/* Copyright (C) 2006 - 2012 Jan Kundrát <jkt@flaska.net>

   This file is part of the Trojita Qt IMAP e-mail client,
   http://trojita.flaska.net/

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or the version 3 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING.  If not, write to
   the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/
#ifndef IMAP_PARSER_RFC5322_H
#define IMAP_PARSER_RFC5322_H

#include <QByteArray>
#include <QList>

namespace Imap {

namespace LowLevelParser {

/** @short Parser for e-mail headers formatted according to the RFC 5322 */
class Rfc5322HeaderParser
{
public:
    Rfc5322HeaderParser();

    void clear();
    bool parse(const QByteArray &data);

    QList<QByteArray> references;
    QList<QByteArray> listPost;
    QList<QByteArray> messageId;
    QList<QByteArray> inReplyTo;
    bool listPostNo;
private:
    bool m_error;
};

}
}

#endif // IMAP_PARSER_RFC5322_H
