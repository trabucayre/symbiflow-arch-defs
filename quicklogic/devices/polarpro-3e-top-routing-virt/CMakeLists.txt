add_file_target(FILE arch.xml SCANNER_TYPE xml)

define_device_type(
  DEVICE_TYPE polarpro-3e-top-routing-virt
  ARCH quicklogic-polarpro-3e
  ARCH_XML arch.xml
  UPDATE_TILES
)
