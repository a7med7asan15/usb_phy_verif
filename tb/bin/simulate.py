import os 
import args 
import helper

## Simulation 
###########################################################
def simulate():
    command = f"vsim {args.GUI} top_opt -l logs/simulation.log -do ./params/run.do " 
    command += f"-sv_seed {args.Seed} " 
    command += f"-wlf logs/vsim.wlf " 
    print(command)
    os.system(command)
    helper.check_error("sim")
