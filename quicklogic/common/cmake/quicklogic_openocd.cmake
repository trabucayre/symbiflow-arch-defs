function(ADD_OPENOCD_OUTPUT)
  # ~~~
  # ADD_OPENOCD_OUTPUT(
  #   PARENT <fpga target name>
  #   IOMUX_JSON <json iomux config>
  #   )
  # ~~~
  set(options)
  set(oneValueArgs PARENT IOMUX_JSON)
  set(multiValueArgs)
  cmake_parse_arguments(
    ADD_OPENOCD_OUTPUT
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  set(PARENT ${ADD_OPENOCD_OUTPUT_PARENT})
  set(IOMUX_JSON ${ADD_OPENOCD_OUTPUT_IOMUX_JSON})

  get_target_property_required(PYTHON3 env PYTHON3)

  get_target_property_required(EBLIF ${PARENT} EBLIF)
  get_target_property_required(PCF ${PARENT} INPUT_IO_FILE)
  get_target_property_required(BITSTREAM ${PARENT} BIT)

  # Get the output directory
  get_file_location(BITSTREAM_LOC ${BITSTREAM})
  get_filename_component(WORK_DIR ${BITSTREAM_LOC} DIRECTORY)
  file(RELATIVE_PATH WORK_DIR_REL ${CMAKE_CURRENT_BINARY_DIR} ${WORK_DIR})

  get_file_location(EBLIF_LOC ${EBLIF})
  get_file_location(PCF_LOC ${PCF})
  get_target_property_required(BOARD ${PARENT} BOARD)

  set(PINMAP ${symbiflow-arch-defs_BINARY_DIR}/quicklogic/pp3/${BOARD}_pinmap.csv)

  # Generate a OpenOCD script that sets IOMUX configuration.
  set(IOMUX_CONFIG_GEN ${symbiflow-arch-defs_SOURCE_DIR}/quicklogic/pp3/utils/eos_s3_iomux_config.py)
  set(IOMUX_CONFIG "top_iomux.openocd")

  set(IOMUX_CONFIG_DEPS)
  set(IOMUX_CONFIG_ARGS "")
  if(DEFINED IOMUX_JSON)
    get_file_location(JSON_LOC ${IOMUX_JSON})
    get_file_target(JSON_DEP ${IOMUX_JSON})
    set(IOMUX_CONFIG_ARGS --json ${JSON_LOC})
    set(IOMUX_CONFIG_DEPS ${JSON_DEP})
  else()
    set(IOMUX_CONFIG_ARGS --eblif ${EBLIF_LOC} --pcf ${PCF_LOC})
    set(IOMUX_CONFIG_DEPS ${EBLIF} ${PCF})
  endif()

  add_custom_command(
    OUTPUT ${WORK_DIR}/${IOMUX_CONFIG}
    COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${symbiflow-arch-defs_SOURCE_DIR}/utils:$PYTHONPATH
      ${PYTHON3} ${IOMUX_CONFIG_GEN}
        ${IOMUX_CONFIG_ARGS}
        --map ${PINMAP}
        --output-format openocd
        >${WORK_DIR}/${IOMUX_CONFIG}
    DEPENDS ${IOMUX_CONFIG_GEN} ${IOMUX_CONFIG_DEPS}
  )

  add_file_target(FILE ${WORK_DIR_REL}/${IOMUX_CONFIG} GENERATED)

  # Convert the binary bitstream to a OpenOCD script
  set(BIT_AS_OPENOCD "top.bit.openocd")

  add_custom_command(
    OUTPUT ${WORK_DIR}/${BIT_AS_OPENOCD}
    COMMAND ${PYTHON3} -m quicklogic_fasm.bitstream_to_openocd ${BITSTREAM_LOC} ${WORK_DIR}/${BIT_AS_OPENOCD}
    DEPENDS ${BITSTREAM}
  )

  add_file_target(FILE ${WORK_DIR_REL}/${BIT_AS_OPENOCD} GENERATED)

  # Concatenate the bitstream OpenOCD script and the IOMUX config OpenOCD script
  set(OUT_OPENOCD "top.openocd")
  add_custom_command(
    OUTPUT ${WORK_DIR}/${OUT_OPENOCD}
    COMMAND head -n -1 ${WORK_DIR}/${BIT_AS_OPENOCD} > ${WORK_DIR}/${OUT_OPENOCD} && cat ${WORK_DIR}/${IOMUX_CONFIG} >> ${WORK_DIR}/${OUT_OPENOCD} && echo '}' >> ${WORK_DIR}/${OUT_OPENOCD}
    DEPENDS ${WORK_DIR}/${BIT_AS_OPENOCD} ${WORK_DIR}/${IOMUX_CONFIG}
  )

  add_custom_target(${PARENT}_openocd DEPENDS ${WORK_DIR}/${OUT_OPENOCD})

endfunction()
