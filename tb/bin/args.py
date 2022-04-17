from ast import parse
import pathlib 
import random
from datetime import datetime
import argparse
import sys


# Colors 
###########################################################
TRED     = '\33[91m'
BRED     = '\33[41m'
TWarning = '\33[93m'
BWarning = '\33[43m'
TSuccess = '\33[92m'
BSuccess = '\33[42m'
TPrim    = '\33[94m'
BPrim    = '\33[44m'
TEND     = '\33[0m' 
###########################################################

# Create the parser
###########################################################
my_parser = argparse.ArgumentParser(fromfile_prefix_chars='@', add_help=False)

# T/F arguments
my_parser.add_argument('--comp_only',action="store_true")
my_parser.add_argument('--tb_only',action="store_true")
my_parser.add_argument('--design_only',action="store_true")
my_parser.add_argument('--gui',action="store_true")

# Input arguments
my_parser.add_argument('--sim_only',type=str)
my_parser.add_argument('-t','--test',type=str, required=True)
my_parser.add_argument('-c','--collection',type=str, required=True)


args_command = my_parser.parse_args()
###########################################################

## Required
###########################################################
TestName   = args_command.test
collectName   = args_command.collection

## Dirs
RootDir    = str((pathlib.Path(__file__).parent / "../../").resolve())
RtlDir     = f"{RootDir}/rtl" 
TBDir      = f"{RootDir}/tb/verif" 
TBSimpleDir= f"{RootDir}/tb/simple" 
EnvDir     = f"{RootDir}/tb/environments/{collectName}" 
EnvDefDir  = f"{RootDir}/tb/environments/default"
TestSVDir  = f"{RootDir}/tb/tests/{collectName}/{TestName}/sv" 
TestDir    = f"{RootDir}/tb/tests/{collectName}/{TestName}" 
###########################################################

## Add Arguments from file to command
###########################################################
parsed_args = sys.argv[1:]
with open(f'{EnvDefDir}/params/run_params', 'r') as f:
    for line in f:
        if line[0] not in ("#", "\n", " "):
            print("_" + line + "_")
            line = line.replace("\n", "")
            parsed_args.append(line)
with open(f'{EnvDir}/params/run_params', 'r') as f:
    for line in f:
        if line[0] not in ("#", "\n", " "):
            print("_" + line + "_")
            line = line.replace("\n", "")
            parsed_args.append(line)
with open(f'{TestDir}/params/run_params', 'r') as f:
    for line in f:
        if line[0] not in ("#", "\n", " "):
            print("_" + line + "_")
            line = line.replace("\n", "")
            parsed_args.append(line) 

print(parsed_args)
args_command = my_parser.parse_args(parsed_args)

print("Here are list of Arguments")
print(args_command)
###########################################################


## Variables 
###########################################################


## Command Args 


## Command Args
GUI_on     = int(args_command.gui)
comp_only  = int(args_command.comp_only)
sim_only   = args_command.sim_only
DesignOnly = args_command.design_only or args_command.test == "no_test"
TBOnly     = args_command.tb_only
SimpleTB   = int(args_command.test == "no_test")
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
    RunDir   = RootDir + "/tb/sim/" + TestName + "_" + dt_string + "_" + Seed

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
