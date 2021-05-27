mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))
TOP		?= top
FAMILY  ?= qlf_k4n8
PINMAP	?= pinmap_${FAMILY}_umc22.csv
TEST 	?=

VERILOG := ${TEST}.v
SDC		:= ${TEST}.sdc
PCF		:= ${TEST}.pcf

all: ${BUILDDIR}/${TOP}.post_ve

${BUILDDIR}/${TOP}.check:
	ql_symbiflow -compile -src ${current_dir} -d ${FAMILY} -t ${TOP} -v ${VERILOG} -p ${PCF} -P ${PINMAP} -s ${SDC}


${BUILDDIR}/${TOP}.bit: ${BUILDDIR}/${TOP}.check
	ql_symbiflow -compile -src ${current_dir} -d ${FAMILY} -t ${TOP} -v ${VERILOG} -p ${PCF} -P ${PINMAP} -s ${SDC}

${BUILDDIR}/${TOP}.post_ve: ${BUILDDIR}/${TOP}.bit
	make -f Makefile.symbiflow build/top.post_v

clean:
	rm -rf ${BUILDDIR}

