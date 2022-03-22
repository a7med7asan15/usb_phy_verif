PROJECT_HOME=$(shell echo $(CURDIR) | sed -r "s+/cygdrive/c/+c:/+" | sed -r "s/sim//")
RANDINT=$(shell shuf -i 1-100 -n 1)
TEST=base_test
SEED=$(RANDINT)
DO="run.do"

ifeq ($(GUI),ON)
MODE=-i
else
MODE=-c
endif

ifeq ($(DBG),ON)
ACC=+acc+/tb_top
endif

ifneq ($(DO),"")
VSIM_DO=-do $(DO)
endif

TB_INCDIR+=

# TB_SRC+= $(PROJECT_HOME)/tb/parameters/*.sv $(PROJECT_HOME)/tb/sequences/*.sv $(PROJECT_HOME)/tb/riscv/analysis/*.sv  
# TB_SRC+= $(PROJECT_HOME)/tb/riscv/*.sv $(PROJECT_HOME)/tb/environment/env_pkg.sv
# TB_SRC+= $(PROJECT_HOME)/tb/tests/*.sv $(PROJECT_HOME)/tb/static/*.sv 

TB_SRC+= $(PROJECT_HOME)/rtl/dut/del/*.sv 

DUT_SRC+=$(PROJECT_HOME)/rtl/dut/rtl/include/*.sv 
DUT_SRC+=$(PROJECT_HOME)/rtl/dut/rtl/*.sv 
DUT_SRC+=$(PROJECT_HOME)/rtl/dut/bhv/include/*.sv 
DUT_SRC+=$(PROJECT_HOME)/rtl/dut/bhv/*.sv 
DUT_SRC+=$(PROJECT_HOME)/rtl/dut/core/include/*.sv 
DUT_SRC+=$(PROJECT_HOME)/rtl/dut/core/*.sv 


VLOG_ARGS+= -sv -work work -l logs/vlog_$@.log 
VSIM_ARGS+=-l logs/vsim_$(TEST)-$(SEED).log $(MODE) +UVM_TESTNAME=$(TEST) -sv_seed $(SEED)
VSIM_ARGS+= -onfinish stop +UVM_VERBOSITY=UVM_HIGH

TOP_OPT=top_opt

# HDL_TOP=hdl_top
# HVL_TOP=hvl_top

HDL_TOP=tb_top
HVL_TOP=cv32e40p_tb_subsystem

help:
	@printf "\033[32mmake help\t\t\tPrints this help message\n"
	@printf "make lib\t\t\tCreates the work library\n"
	@printf "make dut\t\t\tCompiles the DUT \n"
	@printf "make tb\t\t\t\tCompiles the UVM testbench\n"
	@printf "make opt [options]\t\tCreates the simulation image\n"
	@printf "make sim [options]\t\tRuns the simulation\n"
	@printf "make testname\t\t\tReports UVM tests that are available\n"
	@printf "make clean_logs\t\t\tRemoves all logs\n"
	@printf "make clean\t\t\tRemoves all simulation data\n\n"
	@printf "opt options: DBG=ON\t\tCreates a full visibility image. Default off\n"
	@printf "sim options: GUI=ON\t\tOpen an interactive GUI session. Default off\n"
	@printf "sim options: DO=<dofile>\tSpecify a simulation DO file for execution\n"
	@printf "sim options: TEST=<testname>\tSpecify the UVM test to run. Default base_test\n"
	@printf "sim options: SEED=<integer>\tSpecify a random seed value. Default 1\n\n"
	@printf "\033[0m"

lib:
	vlib 	work

dut:
	vlog 	$(VLOG_ARGS) $(VLOG_EXTRA_ARGS) $(DUT_SRC)

tb:
	vlog	$(VLOG_ARGS) $(VLOG_EXTRA_ARGS) $(TB_INCDIR) $(TB_SRC)

opt:
	vopt	$(VOPT_ARGS) $(VOPT_EXTRA_ARGS) $(HVL_TOP) $(HDL_TOP) $(ACC) -o $(TOP_OPT)

sim:
	vsim	$(VSIM_ARGS) $(VSIM_EXTRA_ARGS) $(VSIM_DO) $(TOP_OPT)

testname:
	@printf "\033[32mAvailable UVM tests to run are:\n"
	@ls -1 $(PROJECT_HOME)/tb/tests/src | grep -v base.svh | sed -r "s/.svh//"
	@printf "\033[0m"

all:	clean lib tb dut opt sim

clean:
	clear 
	rm -rf logs work transcript *.log *.wlf *.ucdb *.vstf *traffic *.txt
	mkdir logs

clean_logs:
	rm -rf transcript *.log *.wlf *.ucdb *.vstf *traffic *.txt
