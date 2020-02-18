CMAKE_MINIMUM_REQUIRED(VERSION 3.1)
ADD_DEFINITIONS("-std=c++11")

PROJECT(org.webosports.app.terminal)

include(webOS/webOS)
webos_modules_init(1 0 0 QUALIFIER RC3)
webos_component(0 5 0)

SET(QT_MIN_VERSION  "5.7.0")
set(CMAKE_BUILD_TYPE DEBUG)

IF(POLICY CMP0063)
    CMAKE_POLICY(SET CMP0063 NEW)
ENDIF(POLICY CMP0063)

INCLUDE_DIRECTORIES(SYSTEM ${Qt5Core_INCLUDES})
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/lib/)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/src/)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Core
    Widgets
    Quick
    QuickControls2
)

ADD_DEFINITIONS( -D HAVE_POSIX_OPENPT)
ADD_DEFINITIONS( -D HAVE_SYS_TIME_H)

SET(luneos-terminal_SRC
src/main.cpp
)

QT5_ADD_RESOURCES(luneos-terminal_SRC
    qml.qrc
)

set(CMAKE_AUTOMOC ON)

ADD_EXECUTABLE( luneos-terminal ${luneos-terminal_SRC} )

TARGET_LINK_LIBRARIES( luneos-terminal
    Qt5::Core
    Qt5::Gui
    Qt5::Widgets
    Qt5::Quick
    ${CMAKE_THREAD_LIBS_INIT}
)

SET(APP_DIR ${WEBOS_INSTALL_WEBOS_APPLICATIONSDIR}/org.webosports.app.terminal)

INSTALL( TARGETS luneos-terminal DESTINATION ${APP_DIR} )
INSTALL( FILES appinfo.json  DESTINATION ${APP_DIR} )

