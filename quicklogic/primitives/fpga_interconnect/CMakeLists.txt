add_file_target(FILE fpga_interconnect.sim.v SCANNER_TYPE verilog)

v2x(NAME fpga_interconnect SRCS fpga_interconnect.sim.v)

add_to_cells_sim(fpga_interconnect.sim.v)
