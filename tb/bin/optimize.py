import os 
import args 
import helper

## Optimization 
###########################################################
def optimize():
    command = f"vopt {args.debug} {args.tbTop} -l logs/optimization.log -o top_opt" 
    print(command)
    os.system(command)
    helper.check_error("opt")