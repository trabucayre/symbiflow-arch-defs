set_property PACKAGE_PIN M14 [get_ports led[0]]
set_property PACKAGE_PIN M15 [get_ports led[1]]
set_property PACKAGE_PIN G14 [get_ports led[2]]
set_property PACKAGE_PIN D18 [get_ports led[3]]

set_property IOSTANDARD LVCMOS33 [get_ports led[0]]
set_property IOSTANDARD LVCMOS33 [get_ports led[1]]
set_property IOSTANDARD LVCMOS33 [get_ports led[2]]
set_property IOSTANDARD LVCMOS33 [get_ports led[3]]

create_clock -period 12.5 clk
