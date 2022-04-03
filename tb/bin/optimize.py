import os 
import args 

## Optimization 
###########################################################
def optimize():
    TBTop  = "tb"
    RTLTop = "usbf_top"
    command = f"vopt {args.debug} {TBTop} {RTLTop} -l logs/optimization.log -o top_opt" 
    print(command)
    os.system(command)