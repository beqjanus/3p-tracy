#!/usr/bin/env bash

cd "$(dirname "$0")" 

echo "Building tracy library"

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e
# complain about unset env variables
set -u

# Check autobuild is around or fail
if [ -z "$AUTOBUILD" ] ; then 
    exit 1
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    autobuild="$(cygpath -u $AUTOBUILD)"
else
    autobuild="$AUTOBUILD"
fi

top="$(pwd)"
stage_dir="$(pwd)/stage"
mkdir -p "$stage_dir"
tmp_dir="$(pwd)/tmp"
mkdir -p "$tmp_dir"

# Load autobuild provided shell functions and variables
srcenv_file="$tmp_dir/ab_srcenv.sh"
"$autobuild" source_environment > "$srcenv_file"
. "$srcenv_file"

build_id=${AUTOBUILD_BUILD_ID:=0}
cd tracy
tracy_version="$(git describe --tags --abbrev=0)"
cd ..

echo "${tracy_version}.${build_id}" > "${stage_dir}/VERSION.txt"

mkdir -p "${stage}/include/tracy"

cp tracy/*.hpp "${stage}/include/tracy/"
cp tracy/*.h "${stage}/include/tracy/"
cp tracy/*.cpp "${stage}/include/tracy/"

mkdir -p "${stage}/include/tracy/common"
cp tracy/common/*.hpp "${stage}/include/tracy/common"
cp tracy/common/*.cpp "${stage}/include/tracy/common"
cp tracy/common/*.h "${stage}/include/tracy/common"

mkdir -p "${stage}/include/tracy/client"
cp tracy/client/*.hpp "${stage}/include/tracy/client"
cp tracy/client/*.cpp "${stage}/include/tracy/client"
cp tracy/client/*.h "${stage}/include/tracy/client"

mkdir -p "${stage}/include/tracy/libbacktrace"
cp tracy/libbacktrace/*.hpp "${stage}/include/tracy/libbacktrace"
cp tracy/libbacktrace/*.cpp "${stage}/include/tracy/libbacktrace"
cp tracy/libbacktrace/*.h "${stage}/include/tracy/libbacktrace"


mkdir -p "${stage}/LICENSES"
cp tracy/LICENSE "${stage}/LICENSES/Tracy.txt"