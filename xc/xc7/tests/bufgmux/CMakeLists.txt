# Arty

add_file_target(FILE bufgmux_arty.v SCANNER_TYPE verilog)

add_fpga_target(
  NAME bufgmux_arty
  BOARD arty-full
  SOURCES bufgmux_arty.v
  INPUT_IO_FILE ${COMMON}/arty_swbut.pcf
  EXPLICIT_ADD_FILE_TARGET
)

add_vivado_target(
  NAME bufgmux_arty_vivado
  PARENT_NAME bufgmux_arty
)

# Nexys Video

add_file_target(FILE bufgmux_nexys_video.v SCANNER_TYPE verilog)
add_fpga_target(
  NAME bufgmux_nexys_video
  BOARD nexys_video
  SOURCES bufgmux_nexys_video.v
  INPUT_IO_FILE ${COMMON}/nexys_video.pcf
  INPUT_XDC_FILE ${COMMON}/nexys_video.xdc
  EXPLICIT_ADD_FILE_TARGET
)

add_vivado_target(
  NAME bufgmux_nexys_video_vivado
  PARENT_NAME bufgmux_nexys_video
)
