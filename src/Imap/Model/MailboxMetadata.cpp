/* Copyright (C) 2006 - 2011 Jan Kundrát <jkt@gentoo.org>

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
#include "MailboxMetadata.h"

namespace Imap
{
namespace Mailbox
{


SyncState::SyncState():
    m_exists(0), m_recent(0), m_unSeenCount(0), m_unSeenOffset(0), m_uidNext(0), m_uidValidity(0),
    m_hasExists(false), m_hasRecent(false), m_hasUnSeenCount(false), m_hasUnSeenOffset(false),
    m_hasUidNext(false), m_hasUidValidity(false), m_hasFlags(false),
    m_hasPermanentFlags(false)
{
}

bool SyncState::isUsableForNumbers() const
{
    return m_hasExists && m_hasRecent && m_hasUnSeenCount;
}

bool SyncState::isUsableForSyncing() const
{
    return m_hasExists && m_hasUidNext && m_hasUidValidity;
}

uint SyncState::exists() const
{
    return m_exists;
}

void SyncState::setExists(const uint exists)
{
    m_exists = exists;
    m_hasExists = true;
}

QStringList SyncState::flags() const
{
    return m_flags;
}

void SyncState::setFlags(const QStringList &flags)
{
    m_flags = flags;
    m_hasFlags = true;
}

QStringList SyncState::permanentFlags() const
{
    return m_permanentFlags;
}

void SyncState::setPermanentFlags(const QStringList &permanentFlags)
{
    m_permanentFlags = permanentFlags;
    m_hasPermanentFlags = true;
}

uint SyncState::recent() const
{
    return m_recent;
}

void SyncState::setRecent(const uint recent)
{
    m_recent = recent;
    m_hasRecent = true;
}

uint SyncState::uidNext() const
{
    return m_uidNext;
}

void SyncState::setUidNext(const uint uidNext)
{
    m_uidNext = uidNext;
    m_hasUidNext = true;
}

uint SyncState::uidValidity() const
{
    return m_uidValidity;
}

void SyncState::setUidValidity(const uint uidValidity)
{
    m_uidValidity = uidValidity;
    m_hasUidValidity = true;
}

uint SyncState::unSeenCount() const
{
    return m_unSeenCount;
}

void SyncState::setUnSeenCount(const uint unSeen)
{
    m_unSeenCount = unSeen;
    m_hasUnSeenCount = true;
}

uint SyncState::unSeenOffset() const
{
    return m_unSeenOffset;
}

void SyncState::setUnSeenOffset(const uint unSeen)
{
    m_unSeenOffset = unSeen;
    m_hasUnSeenOffset = true;
}

bool SyncState::completelyEqualTo(const SyncState &other) const
{
    return m_exists == other.m_exists && m_recent == other.m_recent && m_unSeenCount == other.m_unSeenCount &&
            m_unSeenOffset == other.m_unSeenOffset && m_uidNext == other.m_uidNext && m_uidValidity == other.m_uidValidity &&
            m_flags == other.m_flags && m_permanentFlags == other.m_permanentFlags && m_hasExists == other.m_hasExists &&
            m_hasRecent == other.m_hasRecent && m_hasUnSeenCount == other.m_hasUnSeenCount && m_hasUnSeenOffset == other.m_hasUnSeenOffset &&
            m_hasUidNext == other.m_hasUidNext && m_hasUidValidity == other.m_hasUidValidity && m_hasFlags == other.m_hasFlags &&
            m_hasPermanentFlags == other.m_hasPermanentFlags;
}

}
}


QDebug operator<<(QDebug &dbg, const Imap::Mailbox::MailboxMetadata &metadata)
{
    return dbg << metadata.mailbox << metadata.separator << metadata.flags;
}

QDebug operator<<(QDebug &dbg, const Imap::Mailbox::SyncState &state)
{
    return dbg << "UIDVALIDITY" << state.uidValidity() << "UIDNEXT" << state.uidNext() <<
           "EXISTS" << state.exists() << "UNSEEN-count" << state.unSeenCount() <<
           "UNSEEN-offset" << state.unSeenOffset() <<
           "RECENT" << state.recent() << "PERMANENTFLAGS" << state.permanentFlags();
}

QDataStream &operator>>(QDataStream &stream, Imap::Mailbox::SyncState &ss)
{
    uint i;
    QStringList list;
    stream >> i; ss.setExists(i);
    stream >> list; ss.setFlags(list);
    stream >> list; ss.setPermanentFlags(list);
    stream >> i; ss.setRecent(i);
    stream >> i; ss.setUidNext(i);
    stream >> i; ss.setUidValidity(i);
    stream >> i; ss.setUnSeenCount(i);
    stream >> i; ss.setUnSeenOffset(i);
    return stream;
}

QDataStream &operator<<(QDataStream &stream, const Imap::Mailbox::SyncState &ss)
{
    return stream << ss.exists() << ss.flags() << ss.permanentFlags() <<
           ss.recent() << ss.uidNext() << ss.uidValidity() << ss.unSeenCount() << ss.unSeenOffset();
}

QDataStream &operator>>(QDataStream &stream, Imap::Mailbox::MailboxMetadata &mm)
{
    return stream >> mm.flags >> mm.mailbox >> mm.separator;
}

QDataStream &operator<<(QDataStream &stream, const Imap::Mailbox::MailboxMetadata &mm)
{
    return stream << mm.flags << mm.mailbox << mm.separator;
}

