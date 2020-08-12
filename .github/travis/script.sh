#!/bin/bash

source .github/travis/common.sh
set -e

$SPACER

start_section "symbiflow.configure_cmake" "Configuring CMake (make env)"
make env CMAKE_FLAGS="-GNinja"
cd build
end_section "symbiflow.configure_cmake"

$SPACER

make_target all_conda "Setting up basic ${YELLOW}conda environment${NC}"

$SPACER

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

echo "----------------------------------------"
(
    make_target all_quick_tests "Building all quick targets"
)
echo "----------------------------------------"

$SPACER

echo "----------------------------------------"
(
    make_target all_ql_tests "Building all quicklogic tests"
)
echo "----------------------------------------"

$SPACER
