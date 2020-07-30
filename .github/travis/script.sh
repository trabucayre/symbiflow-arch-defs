#!/bin/bash

source .github/travis/common.sh
set -e

$SPACER
# Generate yosys binary for the branch quicklogic-rebased

#setup install path
INSTALL_DIR="$(pwd)/install"

start_section "symbiflow.configure_cmake" "Configuring CMake (make env)"
make env
cd build
end_section "symbiflow.configure_cmake"

$SPACER
make_target all_conda "Setting up basic ${YELLOW}conda environment${NC}"

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

cd quicklogic/pp3/tests
make_target all_quick_tests -j10
