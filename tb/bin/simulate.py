import os 
import args 

## Simulation 
###########################################################
def simulate():
    command = f"vsim {args.GUI} top_opt -l logs/simulation.log -do ./params/run.do" 
    print(command)
    os.system(command)
