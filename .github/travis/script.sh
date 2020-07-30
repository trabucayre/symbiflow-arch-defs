#!/bin/bash

source .github/travis/common.sh
set -e

$SPACER
# Generate yosys binary for the branch quicklogic-rebased

#setup install path
INSTALL_DIR="$(pwd)/install"

#setup ninja
export CMAKE_FLAGS="-GNinja -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}"
export BUILD_TOOL=ninja

$SPACER

start_section "symbiflow.configure_cmake" "Configuring CMake (make env)"
make env
cd build
end_section "symbiflow.configure_cmake"

$SPACER

ninja -j$(nproc) all_conda
#make_target all_conda "Setting up basic ${YELLOW}conda environment${NC}"
cp -r env/conda/share/yosys/* env/conda/share

$SPACER
# Output some useful info
start_section "info.conda.env" "Info on ${YELLOW}conda environment${NC}"
env/conda/bin/conda info
end_section "info.conda.env"

start_section "info.conda.config" "Info on ${YELLOW}conda config${NC}"
env/conda/bin/conda config --show
end_section "info.conda.config"

$SPACER

echo "Running quicklogic testsuit"

#cd quicklogic/pp3/tests
echo "----------------------------------------"
(
#	pushd build
	export VPR_NUM_WORKERS=${nproc}
	ninja -j$(nproc) all_quick_tests
#	popd
)
echo "----------------------------------------"
#make_target all_quick_tests -j10
