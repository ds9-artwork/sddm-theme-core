CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)
CMAKE_POLICY(VERSION 3.0.2)

INCLUDE(${CMAKE_SOURCE_DIR}/Definitions.cmake)

PROJECT(${Project} VERSION ${ver})

CONFIGURE_FILE(
    "${CMAKE_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

   
ADD_CUSTOM_TARGET(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake")

## Update metadata file
CONFIGURE_FILE(
    "${CMAKE_SOURCE_DIR}/src/metadata.desktop.in"
    "${CMAKE_BINARY_DIR}/metadata.desktop"
    IMMEDIATE @ONLY)
    

## Include main files
file(GLOB MAIN "src/*.qml")

## Include metadata
SET (MAIN
    ${MAIN}

    src/theme.conf
    "${CMAKE_BINARY_DIR}/metadata.desktop"
)

## Include components
file(GLOB COMPONENTS "src/components/*.qml")

## Include resources
FILE(GLOB_RECURSE RESOURCES "src/res/*")

SET(THEME_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/share/sddm/themes/${PROJECT_NAME})

INSTALL(FILES ${MAIN} DESTINATION ${THEME_INSTALL_PATH})
INSTALL(FILES ${COMPONENTS} DESTINATION "${THEME_INSTALL_PATH}/components")
INSTALL(FILES ${RESOURCES} DESTINATION "${THEME_INSTALL_PATH}/res")


ADD_CUSTOM_TARGET(dummy_srcs_tracking SOURCES ${MAIN} ${COMPONENTS} ${RESOURCES})
