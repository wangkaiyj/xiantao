QT += quick axcontainer gui network printsupport qml sql widgets winextras

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Framework/appcore.cpp \
        Framework/configs.cpp \
        Framework/models.cpp \
        Framework/sqlitework.cpp \
        Framework/tools.cpp \
        main.cpp

RESOURCES += \
    Resource.qrc

RC_ICONS = logo.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DESTDIR = $${PWD}/../$${TARGET}Exe

include(xlsx/qtxlsx.pri)
include(FramelessHelper/FramelessHelper.pri)

HEADERS += \
    Framework/appcore.h \
    Framework/configs.h \
    Framework/models.h \
    Framework/sqlitework.h \
    Framework/tools.h
