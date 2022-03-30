import pathlib 
import random
from datetime import datetime
## Variables 
###########################################################
TestName   = "hello"
EnvName    = "prod"
RootDir    = str((pathlib.Path(__file__).parent / "../../").resolve())
RtlDir     = f"{RootDir}/rtl" 
TBDir      = f"{RootDir}/tb/verif" 
EnvDir     = f"{RootDir}/tb/environments/{EnvName}" 
TestDir    = f"{RootDir}/tb/tests/{TestName}/sv" 
Seed       = str(round(random.uniform(1111.11, 9999999.99), 2))
GUI_on     = 0
sim_only   = 0
DesignOnly = 1
TBOnly     = 0
DesignTB   = ~(DesignOnly & TBOnly)
# Generate Run Dir based on the seed and date time
now = datetime.now()
dt_string = now.strftime("%Y%m%d_%H%M")
RunDir   = RootDir + "/tb/sim/testname_" + dt_string + "_" + Seed
###########################################################


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
