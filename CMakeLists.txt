cmake_minimum_required(VERSION 3.16)

project(org.webosports.app.terminal LANGUAGES CXX)

include(webOS/webOS)
webos_modules_init(1 0 0 QUALIFIER RC3)
webos_component(0 5 0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Widgets Qml Quick QuickControls2)

add_executable(luneos-terminal src/main.cpp)

target_compile_options(luneos-terminal PRIVATE -Wall -Wextra)
target_compile_definitions(luneos-terminal PRIVATE
    QT_NO_CAST_FROM_ASCII
    QT_NO_CAST_TO_ASCII
    QT_DISABLE_DEPRECATED_UP_TO=0x060500
)

target_link_libraries(luneos-terminal PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

set(APP_DIR ${WEBOS_INSTALL_WEBOS_APPLICATIONSDIR}/org.webosports.app.terminal)

install(TARGETS luneos-terminal DESTINATION ${APP_DIR})
install(FILES appinfo.json icon.png DESTINATION ${APP_DIR})
install(DIRECTORY qml DESTINATION ${APP_DIR})

# luna-service2: the bus name the app manager gives each instance, from which
# the app registers with it (see Main.qml)
configure_file(sysbus/org.webosports.app.terminal.app.json.in
               ${CMAKE_BINARY_DIR}/org.webosports.app.terminal.app.json @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/org.webosports.app.terminal.app.json
        DESTINATION share/luna-service2/roles.d)
install(FILES sysbus/org.webosports.app.terminal.manifest.json
        DESTINATION share/luna-service2/manifests.d)
install(FILES sysbus/org.webosports.app.terminal.perm.json
        DESTINATION share/luna-service2/client-permissions.d)
