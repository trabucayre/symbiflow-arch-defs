function(ADD_JLINK_OUTPUT)
  # ~~~
  # ADD_JLINK_OUTPUT(
  #   PARENT <fpga target name>
  #   IOMUX_JSON <json iomux config>
  #   )
  # ~~~
  set(options)
  set(oneValueArgs PARENT IOMUX_JSON)
  set(multiValueArgs)
  cmake_parse_arguments(
    ADD_JLINK_OUTPUT
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  set(PARENT ${ADD_JLINK_OUTPUT_PARENT})
  set(IOMUX_JSON ${ADD_JLINK_OUTPUT_IOMUX_JSON})

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

  # Generate a JLINK script that sets IOMUX configuration.
  set(IOMUX_CONFIG_GEN ${symbiflow-arch-defs_SOURCE_DIR}/quicklogic/pp3/utils/eos_s3_iomux_config.py)
  set(IOMUX_CONFIG "top_iomux.jlink")

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
        --output-format jlink
        >${WORK_DIR}/${IOMUX_CONFIG}
    DEPENDS ${IOMUX_CONFIG_GEN} ${IOMUX_CONFIG_DEPS}
  )

  add_file_target(FILE ${WORK_DIR_REL}/${IOMUX_CONFIG} GENERATED)

  # Convert the binary bitstream to a JLINK script
  set(BIT_AS_JLINK "top.bit.jlink")

  add_custom_command(
    OUTPUT ${WORK_DIR}/${BIT_AS_JLINK}
    COMMAND ${PYTHON3} -m quicklogic_fasm.bitstream_to_jlink ${BITSTREAM_LOC} ${WORK_DIR}/${BIT_AS_JLINK}
    DEPENDS ${BITSTREAM}
  )

  add_file_target(FILE ${WORK_DIR_REL}/${BIT_AS_JLINK} GENERATED)

  # Concatenate th bitstream JLink script and the IOMUX config JLink script
  set(OUT_JLINK "top.jlink")
  add_custom_command(
    OUTPUT ${WORK_DIR}/${OUT_JLINK}
    COMMAND cat ${WORK_DIR}/${BIT_AS_JLINK} ${WORK_DIR}/${IOMUX_CONFIG} >${WORK_DIR}/${OUT_JLINK}
    DEPENDS ${WORK_DIR}/${BIT_AS_JLINK} ${WORK_DIR}/${IOMUX_CONFIG}
  )

  add_custom_target(${PARENT}_jlink DEPENDS ${WORK_DIR}/${OUT_JLINK})


  set(DESIGN_CMDS "jlink_cmds.txt")
  set(OUT_JLINK_COPY "jlink_cmds_copy.txt")
  set(JLINK_SCRIPT "jlink_script.sh")
  set(JLINK_GOLD "jlink_out_gold")
  add_custom_command(
    OUTPUT ${WORK_DIR}/${OUT_JLINK_COPY}
    DEPENDS ${WORK_DIR}/${OUT_JLINK} ${DESIGN_CMDS} ${JLINK_SCRIPT} ${JLINK_GOLD}
  )

  add_custom_target(${PARENT}_jlink_copy DEPENDS ${WORK_DIR}/${OUT_JLINK_COPY} )

  set(OUT_JLINK_HARDWARE "top.jlink_hardware")
  set(JLINK_EXE "/usr/bin/JLinkExe")
  add_custom_command(
    OUTPUT ${WORK_DIR}/${OUT_JLINK_HARDWARE}
    COMMAND cp ${WORK_DIR}/${OUT_JLINK} ${WORK_DIR}/../../${OUT_JLINK}
    COMMAND bash ${WORK_DIR}/../../${JLINK_SCRIPT}
    COMMAND ${JLINK_EXE} -Device Cortex-M4 -If SWD -Speed 4000 -commandFile "top.jlink"
    COMMAND ${JLINK_EXE} -Device Cortex-M4 -If SWD -Speed 4000 -commandFile "jlink_cmds.txt" >jlink_out
    COMMAND sed -i '/VTref/d' jlink_out
    COMMAND diff jlink_out jlink_out_gold > top.jlink_hardware 2>&1
    DEPENDS ${WORK_DIR}/${OUT_JLINK}
  )

  add_custom_target(${PARENT}_jlink_hardware DEPENDS ${PARENT}_jlink_copy ${WORK_DIR}/${OUT_JLINK_HARDWARE})

endfunction()
