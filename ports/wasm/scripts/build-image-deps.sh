#!/usr/bin/env bash
# Build the image modules and mesh codec used by the upstream 3MF importer.
set -euo pipefail

install_dir=$1
sources=$2
mkdir -p "$sources"
common=(-G Ninja -DCMAKE_BUILD_TYPE=Release "-DCMAKE_INSTALL_PREFIX=$install_dir"
    -DBUILD_SHARED_LIBS=OFF "-DCMAKE_CXX_FLAGS=$EXTRA_CXX_FLAGS" "-DCMAKE_C_FLAGS=$EXTRA_C_FLAGS")

if [[ ! -f "$install_dir/.opencv-4.14.0" ]]; then
    archive="$sources/opencv-4.14.0.tar.gz"
    [[ -f "$archive" ]] || curl -fsSL --retry 3 https://github.com/opencv/opencv/archive/refs/tags/4.14.0.tar.gz -o "$archive"
    echo "ee8fb9b30eb60850431b4656447080e3737b56e45719c92b67f245950609f86e  $archive" | shasum -a 256 -c -
    tar -xzf "$archive" -C "$sources"
    emcmake cmake -S "$sources/opencv-4.14.0" -B "$sources/opencv-build" "${common[@]}" \
        -DBUILD_LIST=core,imgproc,imgcodecs -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
        -DBUILD_EXAMPLES=OFF -DBUILD_opencv_apps=OFF -DBUILD_opencv_js=OFF \
        -DWITH_IPP=OFF -DWITH_ITT=OFF -DWITH_OPENCL=OFF -DWITH_ADE=OFF \
        -DWITH_WEBP=OFF -DWITH_TIFF=OFF -DWITH_OPENJPEG=OFF -DWITH_OPENEXR=OFF \
        -DWITH_JASPER=OFF -DWITH_AVIF=OFF -DWITH_JPEG=ON -DWITH_PNG=ON \
        -DBUILD_JPEG=ON -DBUILD_PNG=ON -DBUILD_ZLIB=ON -DCV_ENABLE_INTRINSICS=OFF
    cmake --build "$sources/opencv-build" --target install -j "${CMAKE_BUILD_PARALLEL_LEVEL:-4}"
    touch "$install_dir/.opencv-4.14.0"
fi

if [[ ! -f "$install_dir/.draco-1.5.7" ]]; then
    archive="$sources/draco-1.5.7.zip"
    [[ -f "$archive" ]] || curl -fsSL --retry 3 https://github.com/google/draco/archive/refs/tags/1.5.7.zip -o "$archive"
    echo "27b72ba2d5ff3d0a9814ad40d4cb88f8dc89a35491c0866d952473f8f9416b77  $archive" | shasum -a 256 -c -
    unzip -qo "$archive" -d "$sources"
    emcmake cmake -S "$sources/draco-1.5.7" -B "$sources/draco-build" "${common[@]}" \
        -DDRACO_JS_GLUE=OFF -DDRACO_TESTS=OFF
    cmake --build "$sources/draco-build" --target install -j "${CMAKE_BUILD_PARALLEL_LEVEL:-4}"
    touch "$install_dir/.draco-1.5.7"
fi
