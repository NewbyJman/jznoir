cmake_minimum_required(VERSION 3.16)
project(JZNoir)

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)
find_package(TagLib REQUIRED)
find_package(VLC REQUIRED)

add_executable(JZNoir
    src/main.cpp
    src/AudioEngine.cpp
    src/LibraryScanner.cpp
    src/MetadataReader.cpp
)

target_link_libraries(JZNoir
    Qt6::Quick Qt6::Qml
    ${TAGLIB_LIBRARIES} ${VLC_LIBRARIES}
)

file(GLOB QML_FILES "qml/*.qml")
qt_add_qml_module(JZNoir
    URI "JZNoir"
    VERSION 1.0
    QML_FILES ${QML_FILES}
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)

# Handle assets
file(COPY "qml/logo.png" DESTINATION ${CMAKE_BINARY_DIR})