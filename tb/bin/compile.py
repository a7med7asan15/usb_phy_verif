import os 
import args 
import helper

## Compilation 
###########################################################
def compile():
    rtl_comp = f"-f {args.RunDir}/lists/rtl_verilog_files.list "
    tb_comp  = f"-f {args.RunDir}/lists/tb.list -f {args.RunDir}/lists/env.list "
    test_comp  = f"-f {args.RunDir}/lists/test.list "

    command = f"vlog -sv " 
            
    if args.DesignOnly == 1: 
        command += f"{rtl_comp}"

    if args.TBOnly == 1: 
        command += f"{tb_comp}"
        command += f"{test_comp}"

    if args.DesignTB == 1: 
        command += f"{rtl_comp}"
        command += f"{tb_comp}"
        command += f"{test_comp}"

    if args.SimpleTB == 1: 
        command += f"{test_comp}"

    command += f"-l logs/verilog_comp.log"           
    print(command)
    os.system(command)
    helper.check_error("comp")
###########################################################
