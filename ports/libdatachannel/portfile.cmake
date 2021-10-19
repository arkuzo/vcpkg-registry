vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO arkuzo/libdatachannel
        REF dcdaa6b9e3400035e11a97fa9ecfe42ac7c80ec6 #v0.15.1
        SHA512 4bd208b77b2ab58e2a3d51757bac320e68c7996940fcb280360f3add7fdffbd8ba14017d8618ce696fcc98b969e2c0e415aba0cce98dee70665bd666b81d3500
        HEAD_REF voronin_patch
        PATCHES
        0001-fix-for-vcpkg.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
        FEATURES
        stdcall CAPI_STDCALL
        INVERTED_FEATURES
        ws NO_WEBSOCKET
        srtp NO_MEDIA
        )

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
        ${FEATURE_OPTIONS}
        -DUSE_SYSTEM_SRTP=ON
        -DNO_EXAMPLES=ON
        -DNO_TESTS=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME LibDataChannel CONFIG_PATH lib/cmake/LibDataChannel)
vcpkg_fixup_pkgconfig()

file(READ "${CURRENT_PACKAGES_DIR}/share/LibDataChannel/LibDataChannelConfig.cmake" DATACHANNEL_CONFIG)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/LibDataChannel/LibDataChannelConfig.cmake" "
include(CMakeFindDependencyMacro)
find_dependency(Threads)
find_dependency(OpenSSL)
find_dependency(LibJuice)
${DATACHANNEL_CONFIG}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)