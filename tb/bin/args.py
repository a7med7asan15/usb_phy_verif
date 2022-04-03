import pathlib 
import random
from datetime import datetime
import argparse

# Colors 
TRED = '\33[91m'
BRED = '\33[41m'

TWarning = '\33[93m'
BWarning = '\33[43m'

TSuccess = '\33[92m'
BSuccess = '\33[42m'

TPrim = '\33[94m'
BPrim = '\33[44m'

TEND = '\33[0m'

       
# Create the parser
my_parser = argparse.ArgumentParser(description='List the content of a folder')

# T/F arguments
my_parser.add_argument('--comp_only',action="store_true")
my_parser.add_argument('--tb_only',action="store_true")
my_parser.add_argument('--design_only',action="store_true")
my_parser.add_argument('--gui',action="store_true")
my_parser.add_argument('--simple_tb',action="store_true")

# Input arguments
my_parser.add_argument('--sim_only',type=str)


# Execute the parse_args() method
args_command = my_parser.parse_args()


## Variables 
###########################################################
## Command Args 
TestName   = "hello"
#EnvName    = "prod"

## Dirs
RootDir    = str((pathlib.Path(__file__).parent / "../../").resolve())
RtlDir     = f"{RootDir}/rtl" 
TBDir      = f"{RootDir}/tb/verif" 
TBSimpleDir= f"{RootDir}/tb/simple" 
#EnvDir     = f"{RootDir}/tb/environments/{EnvName}" 
TestSVDir  = f"{RootDir}/tb/tests/{TestName}/sv" 
TestDir    = f"{RootDir}/tb/tests/{TestName}" 

## Command Args
GUI_on     = int(args_command.gui)
comp_only  = int(args_command.comp_only)
sim_only   = args_command.sim_only
DesignOnly = args_command.design_only or args_command.simple_tb
TBOnly     = args_command.tb_only
SimpleTB   = int(args_command.simple_tb)
DesignTB   = not (DesignOnly or TBOnly)

## Editable Args 
debug      = "+acc+/tb/dut"

# Generate Run Dir based on the seed and date time
Seed       = str(round(random.uniform(1111.11, 9999999.99), 2))
now = datetime.now()
dt_string = now.strftime("%Y%m%d_%H%M")

if sim_only: 
    RunDir   = RootDir + "/tb/sim/" + sim_only
else: 
    RunDir   = RootDir + "/tb/sim/testname_" + dt_string + "_" + Seed
###########################################################

if GUI_on == 0: 
    GUI = "-c"
elif GUI_on == 1:
    GUI = "-gui"


# Contents: 
#  - Compilation 
#  - Optimization 
#  - Simulation 


""" 
Some Arguments: 
- comp_args 
- sim_args 
- opt_args 
- design_only 
- tb_only 
- comp_only 
- sim_only
- gui 
- dump_size 
- dump 
- do_file
- t: test
"""
