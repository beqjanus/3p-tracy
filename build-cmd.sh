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
tracy_public="$(pwd)/tracy/public"
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

mkdir -p "${stage_dir}/include/tracy"

# cp ${tracy_public}/*.hpp "${stage_dir}/include/tracy/"
# cp ${tracy_public}/*.h "${stage_dir}/include/tracy/"
cp ${tracy_public}/*.cpp "${stage_dir}/include/tracy/"

mkdir -p "${stage_dir}/include/tracy/tracy"
cp ${tracy_public}/tracy/*.hpp "${stage_dir}/include/tracy/tracy"
cp ${tracy_public}/tracy/*.h "${stage_dir}/include/tracy/tracy"

mkdir -p "${stage_dir}/include/tracy/common"
cp ${tracy_public}/common/*.hpp "${stage_dir}/include/tracy/common"
cp ${tracy_public}/common/*.cpp "${stage_dir}/include/tracy/common"
cp ${tracy_public}/common/*.h "${stage_dir}/include/tracy/common"

mkdir -p "${stage_dir}/include/tracy/client"
cp ${tracy_public}/client/*.hpp "${stage_dir}/include/tracy/client"
cp ${tracy_public}/client/*.cpp "${stage_dir}/include/tracy/client"
cp ${tracy_public}/client/*.h "${stage_dir}/include/tracy/client"

mkdir -p "${stage_dir}/include/tracy/libbacktrace"
cp ${tracy_public}/libbacktrace/*.hpp "${stage_dir}/include/tracy/libbacktrace"
cp ${tracy_public}/libbacktrace/*.cpp "${stage_dir}/include/tracy/libbacktrace"
cp ${tracy_public}/libbacktrace/*.h "${stage_dir}/include/tracy/libbacktrace"


mkdir -p "${stage_dir}/LICENSES"
cp ${tracy_public}/../LICENSE "${stage_dir}/LICENSES/Tracy.txt"