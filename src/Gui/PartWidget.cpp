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
#include "PartWidget.h"

#include <QLabel>
#include <QModelIndex>
#include <QVBoxLayout>

#include "PartWidgetFactory.h"
#include "Rfc822HeaderView.h"
#include "Imap/Model/ItemRoles.h"
#include "Imap/Model/MailboxTree.h"

namespace Gui {

QString quoteMeHelper( const QObjectList& children )
{
    QStringList res;
    for ( QObjectList::const_iterator it = children.begin(); it != children.end(); ++it ) {
        const AbstractPartWidget* w = dynamic_cast<const AbstractPartWidget*>( *it );
        if ( w )
            res += w->quoteMe();
    }
    return res.join("\n");
}

MultipartAlternativeWidget::MultipartAlternativeWidget(QWidget *parent,
    PartWidgetFactory *factory, const QModelIndex &partIndex,
    const int recursionDepth ):
        QTabWidget( parent )
{
    for (int i = 0; i < partIndex.model()->rowCount(partIndex); ++i) {
        using namespace Imap::Mailbox;
        QModelIndex anotherPart = partIndex.child(i, 0);
        Q_ASSERT(anotherPart.isValid());
        QWidget* item = factory->create(anotherPart, recursionDepth + 1);
        addTab(item, anotherPart.data(Imap::Mailbox::RolePartMimeType).toString());
    }
    setCurrentIndex(partIndex.model()->rowCount(partIndex) - 1);
}

QString MultipartAlternativeWidget::quoteMe() const
{
    const AbstractPartWidget* w = dynamic_cast<const AbstractPartWidget*>(currentWidget());
    return w ? w->quoteMe() : QString();
}

void MultipartAlternativeWidget::reloadContents()
{
    if ( count() ) {
        for ( int i = 0; i < count(); ++i ) {
            AbstractPartWidget* w = dynamic_cast<AbstractPartWidget*>(widget(i));
            if ( w ) {
                w->reloadContents();
            }
        }
    }
}

MultipartSignedWidget::MultipartSignedWidget(QWidget *parent,
    PartWidgetFactory *factory, const QModelIndex &partIndex,
    const int recursionDepth ):
        QGroupBox( tr("Signed Message"), parent )
{
    using namespace Imap::Mailbox;
    QVBoxLayout* layout = new QVBoxLayout( this );
    uint childrenCount = partIndex.model()->rowCount(partIndex);
    if (childrenCount == 1) {
        setTitle(tr("Mallformed multipart/signed message: only one nested part"));
        QModelIndex anotherPart = partIndex.child(0, 0);
        Q_ASSERT(anotherPart.isValid()); // guaranteed by the MVC
        layout->addWidget(factory->create(anotherPart, recursionDepth + 1));
    } else if (childrenCount != 2) {
        QLabel* lbl = new QLabel(tr("Mallformed multipart/signed message: %1 nested parts").arg(QString::number(childrenCount)), this );
        layout->addWidget(lbl);
        return;
    } else {
        Q_ASSERT(childrenCount == 2); // from the if logic; FIXME: refactor
        QModelIndex anotherPart = partIndex.child(0, 0);
        Q_ASSERT(anotherPart.isValid()); // guaranteed by the MVC
        layout->addWidget(factory->create(anotherPart, recursionDepth + 1));
    }
}

QString MultipartSignedWidget::quoteMe() const
{
    return quoteMeHelper( children() );
}

GenericMultipartWidget::GenericMultipartWidget(QWidget *parent,
    PartWidgetFactory *factory, const QModelIndex &partIndex,
    int recursionDepth):
        QGroupBox( tr("Multipart Message"), parent )
{
    // multipart/mixed or anything else, as mandated by RFC 2046, Section 5.1.3
    QVBoxLayout* layout = new QVBoxLayout( this );
    for (int i = 0; i < partIndex.model()->rowCount(partIndex); ++i) {
        using namespace Imap::Mailbox;
        QModelIndex anotherPart = partIndex.child(i, 0);
        Q_ASSERT(anotherPart.isValid()); // guaranteed by the MVC
        QWidget* res = factory->create(anotherPart, recursionDepth + 1);
        layout->addWidget(res);
    }
}

QString GenericMultipartWidget::quoteMe() const
{
    return quoteMeHelper(children());
}

Message822Widget::Message822Widget(QWidget *parent,
    PartWidgetFactory *factory, const QModelIndex &partIndex,
    int recursionDepth):
        QGroupBox( tr("Message"), parent )
{
    QVBoxLayout* layout = new QVBoxLayout(this);
    QLabel* header = new Rfc822HeaderView(0, partIndex);
    layout->addWidget( header );
    for (int i = 0; i < partIndex.model()->rowCount(partIndex); ++i) {
        using namespace Imap::Mailbox;
        QModelIndex anotherPart = partIndex.child(i, 0);
        Q_ASSERT(anotherPart.isValid()); // guaranteed by the MVC
        QWidget* res = factory->create(anotherPart, recursionDepth + 1);
        layout->addWidget(res);
    }
}

QString Message822Widget::quoteMe() const
{
    return quoteMeHelper( children() );
}

#define IMPL_RELOAD(CLASS) void CLASS::reloadContents() \
{\
    /*qDebug() << metaObject()->className() << children().size();*/\
    Q_FOREACH( QObject* const obj, children() ) {\
        /*qDebug() << obj->metaObject()->className();*/\
        AbstractPartWidget* w = dynamic_cast<AbstractPartWidget*>( obj );\
        if ( w ) {\
            /*qDebug() << "reloadContents:" << w;*/\
            w->reloadContents();\
        }\
    }\
}

IMPL_RELOAD(MultipartSignedWidget);
IMPL_RELOAD(GenericMultipartWidget);
IMPL_RELOAD(Message822Widget);

#undef IMPL_RELOAD


}


