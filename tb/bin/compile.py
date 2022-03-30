import os 
import args 

## Compilation 
###########################################################
def compile():
    rtl_comp = f"-f {args.RunDir}/lists/rtl_verilog_files.list "
    tb_comp  = f"-f {args.RunDir}/lists/tb.list -f {args.RunDir}/lists/env.list -f {args.RunDir}/lists/test.list "

    command = f"vlog -sv " 
            
    if args.DesignOnly == 1: 
        command += f"{rtl_comp}"

    if args.TBOnly == 1: 
        command += f"{tb_comp}"

    if args.DesignTB == 1: 
        command += f"{rtl_comp}"
        command += f"{tb_comp}"
    
    print("Hello " + str(args.DesignTB))
    command += f"-l logs/verilog_comp.log"
    if args.sim_only == 0:            
        print(command)
        os.system(command)
###########################################################
