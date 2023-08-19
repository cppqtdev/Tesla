QT += quick svg multimedia widgets core network positioning qml

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

#/*
  #UI design
  #https://www.figma.com/proto/ZVtsja4HrrnTepCXy4UL1o/Tesla-Model-3-(Community)?type=design&node-id=193-11415&t=IRGHY8V169BrNXsq-0&scaling=scale-down&page-id=0%3A1
#*/
SOURCES += \
        Music/cpp/qmlinterface.cpp \
        Music/cpp/radialbar.cpp \
        main.cpp \
        svgimageprovider.cpp \
        teslasettings.cpp \
        whether/appmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	Music/cpp/qmlinterface.h \
	Music/cpp/radialbar.h \
	svgimageprovider.h \
	teslasettings.h \
	whether/appmodel.h
