#!/bin/bash

source $(dirname "$0")/common.sh
set -e

start_section "symbiflow.configure_cmake" "Configuring CMake (make env)"
make env
source env/conda/bin/activate symbiflow_arch_def_base
cd build
end_section "symbiflow.configure_cmake"

# Output some useful info
start_section "info.conda.env" "Info on ${YELLOW}conda environment${NC}"
conda info
end_section "info.conda.env"

start_section "info.conda.config" "Info on ${YELLOW}conda config${NC}"
conda config --show
end_section "info.conda.config"

# Code formatting
start_section "symbiflow.code_formatting" "Checking code formatting"
make_target check_python "Check code formatting"
make_target lint_python "Check code style"
end_section "symbiflow.code_formatting"

# Python unit tests
start_section "symbiflow.python_tests" "Running Python unit tests"
make_target test_python
end_section "symbiflow.python_tests"

# QuickLogic tests
start_section "symbiflow.quicklogic_tests" "Running all QuickLogic tests"
make_target all_quicklogic_tests
end_section "symbiflow.quicklogic_tests"
