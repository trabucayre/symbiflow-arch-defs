add_subdirectory(cblock)
add_file_target(FILE ql.sim.v SCANNER_TYPE verilog)
v2x_test_both(NAME ql TOP_MODULE QL)
