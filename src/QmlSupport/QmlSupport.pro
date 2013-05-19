TEMPLATE = subdirs
SUBDIRS  = ModelGlue

lessThan(QT_MAJOR_VERSION, 5) {
    SUBDIRS += QNAMWebView
}
