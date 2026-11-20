# The prusaslicer_ prefix keeps our libpng from clashing with a system libpng at
# link time on desktops, but iOS and Android ship no libpng at all. Skipping the
# prefix there lets OpenCV's bundled PNG codec resolve against the same libpng —
# with the prefix, its unprefixed png_* references were unresolved at final link.
if (DEPS_IOS OR DEPS_ANDROID)
    set(_png_prefix "")
else ()
    set(_png_prefix "-DPNG_PREFIX=prusaslicer_")
endif ()

orcaslicer_add_cmake_project(PNG
        URL https://github.com/glennrp/libpng/archive/refs/tags/v1.6.59.zip
        URL_HASH SHA256=6fd97a1e5e2ac55cec0a538a9800a351eb3844086736291844ebd12db72ba433
        DEPENDS ${ZLIB_PKG}
        CMAKE_ARGS
            -DPNG_SHARED=OFF
            -DPNG_STATIC=ON
            "${_png_prefix}"
            -DPNG_TESTS=OFF
            -DDISABLE_DEPENDENCY_TRACKING=OFF
)

if (MSVC)
    add_debug_dep(dep_PNG)
endif ()
