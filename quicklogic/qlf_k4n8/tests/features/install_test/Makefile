mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))
TOP		?= top
FAMILY  ?= qlf_k4n8
PINMAP	?= pinmap_${FAMILY}_umc22.csv
TEST 	?=

VERILOG := ${TEST}.v
SDC		:= ${TEST}.sdc
PCF		:= ${TEST}.pcf

all: ${BUILDDIR}/${TOP}.post_verilog

${BUILDDIR}/${TOP}.check_no_pcf_no_pinmap:
	ql_symbiflow -compile -src ${current_dir} -d ${FAMILY} -t ${TOP} -v ${VERILOG}

${BUILDDIR}/${TOP}.check_no_pcf: ${BUILDDIR}/${TOP}.check_no_pcf_no_pinmap
	ql_symbiflow -compile -src ${current_dir} -d ${FAMILY} -t ${TOP} -v ${VERILOG} -P ${PINMAP}

${BUILDDIR}/${TOP}.bit: ${BUILDDIR}/${TOP}.check_no_pcf
	ql_symbiflow -compile -src ${current_dir} -d ${FAMILY} -t ${TOP} -v ${VERILOG} -p ${PCF} -P ${PINMAP} -s ${SDC}

${BUILDDIR}/${TOP}.post_verilog: ${BUILDDIR}/${TOP}.bit
	make -f Makefile.symbiflow build/top.post_verilog

clean:
	rm -rf ${BUILDDIR}

