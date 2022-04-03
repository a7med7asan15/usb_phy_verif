import os 
import args 

## Simulation 
###########################################################
def simulate():
    command = f"vsim {args.GUI} top_opt -l logs/simulation.log -do ./params/run.do " 
    command += f"-sv_seed {args.Seed} " 
    print(command)
    os.system(command)
