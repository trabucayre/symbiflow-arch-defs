# This file has been prepared by Digilent and edited for use in this project.
# Upstream source:
# https://github.com/Digilent/digilent-xdc/blob/master/Nexys-Video-Master.xdc

## Clock Signal
set_property -dict IOSTANDARD LVCMOS33 [get_ports { IO_CLK }]; #IO_L13P_T2_MRCC_34 Sch=sysclk


## LEDs
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP8 }]; #IO_L15P_T2_DQS_13 Sch=led[0]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP9 }]; #IO_L15N_T2_DQS_13 Sch=led[1]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP10 }]; #IO_L17P_T2_13 Sch=led[2]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP11 }]; #IO_L17N_T2_13 Sch=led[3]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP12 }]; #IO_L14N_T2_SRCC_13 Sch=led[4]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP13 }]; #IO_L16N_T2_13 Sch=led[5]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP14 }]; #IO_L16P_T2_13 Sch=led[6]
set_property IOSTANDARD LVCMOS25 [get_ports { IO_GP15 }]; #IO_L5P_T0_13 Sch=led[7]


## Buttons
set_property IOSTANDARD LVCMOS15 [get_ports { IO_RST_N }]; #IO_L12N_T1_MRCC_35 Sch=cpu_resetn


## Switches
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP0 }]; #IO_L22P_T3_16 Sch=sw[0]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP1 }]; #IO_25_16 Sch=sw[1]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP2 }]; #IO_L24P_T3_16 Sch=sw[2]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP3 }]; #IO_L24N_T3_16 Sch=sw[3]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP4 }]; #IO_L6P_T0_15 Sch=sw[4]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP5 }]; #IO_0_15 Sch=sw[5]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP6 }]; #IO_L19P_T3_A22_15 Sch=sw[6]
set_property IOSTANDARD LVCMOS12 [get_ports { IO_GP7 }]; #IO_25_15 Sch=sw[7]


## UART
set_property IOSTANDARD LVCMOS33 [get_ports { IO_UTX }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=uart_rx_out
set_property IOSTANDARD LVCMOS33 [get_ports { IO_URX }]; #IO_L14P_T2_SRCC_14 Sch=uart_tx_in


## DPTI/DSPI
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS0 }]; #IO_L11P_T1_SRCC_14 Sch=prog_d0/sck
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS1 }]; #IO_L19P_T3_A10_D26_14 Sch=prog_d1/mosi
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS2 }]; #IO_L22P_T3_A05_D21_14 Sch=prog_d2/miso
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS3 }]; #IO_L18P_T2_A12_D28_14 Sch=prog_d3/ss
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS4 }]; #IO_L24N_T3_A00_D16_14 Sch=prog_d[4]
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS5 }]; #IO_L24P_T3_A01_D17_14 Sch=prog_d[5]
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS6 }]; #IO_L20P_T3_A08_D24_14 Sch=prog_d[6]
set_property IOSTANDARD LVCMOS33 [get_ports { IO_DPS7 }]; #IO_L23N_T3_A02_D18_14 Sch=prog_d[7]

set_property PULLTYPE PULLUP [get_ports { IO_DPS5 }]; #IO_L24P_T3_A01_D17_14 Sch=prog_d[5]
set_property PULLTYPE PULLDOWN [get_ports { IO_DPS6 }]; #IO_L20P_T3_A08_D24_14 Sch=prog_d[6]
set_property PULLTYPE PULLDOWN [get_ports { IO_DPS7 }]; #IO_L23N_T3_A02_D18_14 Sch=prog_d[7]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
