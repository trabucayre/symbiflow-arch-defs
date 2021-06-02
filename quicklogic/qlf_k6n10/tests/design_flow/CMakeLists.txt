#Testcases for the design flow
add_subdirectory(counter)
add_subdirectory(adder_8)
add_subdirectory(and2)
add_subdirectory(and2_latch)
add_subdirectory(bin2bcd)
add_subdirectory(rs_decoder_1)
# FIXME: Temoprarly disabled. This tests uses the same source files as one for
# qlf_k4n8 which creates a conflict in CMake (two targets of the same name).
#add_subdirectory(unsigned_mult_80)
add_subdirectory(adder_64)
add_subdirectory(top_120_13)
add_subdirectory(multiplier_8bit)
add_subdirectory(shift_reg_8192)
add_subdirectory(bram)
#add_subdirectory(VexRiscv)
#add_subdirectory(conv2d)
#add_subdirectory(conv2d_no_ksa)
#TODO: Add this testcase after yosys plugin support dsp
#add_subdirectory(mac_16)

#The k6n10 architecture can be scaled up to be able to run
#Ressource consuming testcases below

#add_subdirectory(multi_enc_decx2x4) #1026 IO required
