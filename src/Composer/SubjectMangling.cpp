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

#include <QObject>
#include <QRegExp>

#include "SubjectMangling.h"

namespace Composer {
namespace Util {

/** @short Prepare a subject to be used in a reply message */
QString replySubject(const QString &subject)
{
    // These operations should *not* check for internationalized variants of "Re"; these are evil.

    static QRegExp rePrefixMatcher(QLatin1String("^((Re:\\s?)+)(.*)"), Qt::CaseInsensitive);
    QLatin1String correctedPrefix("Re: ");

    if (rePrefixMatcher.indexIn(subject) == -1) {
        return correctedPrefix + subject;
    } else {
        return correctedPrefix + rePrefixMatcher.cap(3);
    }
}

}
}

