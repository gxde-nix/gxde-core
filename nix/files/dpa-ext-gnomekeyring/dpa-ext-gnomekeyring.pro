TEMPLATE = lib
TARGET = dpa-ext-gnomekeyring
CONFIG += plugin link_pkgconfig c++11
QT += widgets
PKGCONFIG += gnome-keyring-1
INCLUDEPATH += include
SOURCES += gnomekeyringextention.cpp
HEADERS += gnomekeyringextention.h
