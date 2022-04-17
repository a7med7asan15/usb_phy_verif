import os
import sys
import args 
import shutil
from subprocess import check_output

## Some Checks
###########################################################
def throw_err(err): 
    print(args.BRED + f"{err}" + args.TEND)

def throw_success(err): 
    print(args.BSuccess + f"{err}" + args.TEND)

def throw_warning(err): 
    print(args.BWarning + f"{err}" + args.TEND)

def print_info(info): 
    print(args.BPrim + info + args.TEND)

def check_test(): 
    if args.TestName: 
        print(args.TestName)
    else: 
        if args.SimpleTB: 
            print(args.SimpleTB)
        else: 
            throw_err("No test specified")
            sys.exit()


def check_path(): 
    if not os.path.isdir(args.RtlDir):
        throw_err("RTL path specified does not exist")
        sys.exit()

    if not os.path.isdir(args.RunDir):
        if args.sim_only:
            throw_err("Simulation Directory does not exist")
            sys.exit()    
        else: 
            os.mkdir(args.RunDir)
            os.mkdir(args.RunDir+"/lists")
            os.mkdir(args.RunDir+"/logs")

def do_checks(): 
    check_test()
    check_path()
###########################################################

## Generating lists
###########################################################
def generate_lists():
    RtlVerilogFiles = [os.path.join(path, name) for path, subdirs, files in os.walk(args.RtlDir) for name in files if name.endswith(".v") or name.endswith(".sv")]
    #RtlVhdlFiles    = [os.path.join(path, name) for path, subdirs, files in os.walk(RtlDir) for name in files if name.endswith(".vhd")]
    TBFiles         = [os.path.join(path, name) for path, subdirs, files in os.walk(args.TBDir) for name in files if name.endswith(".sv")]
    EnvFiles        = [os.path.join(path, name) for path, subdirs, files in os.walk(args.EnvDir) for name in files if name.endswith(".sv")]
    EnvFiles       += [os.path.join(path, name) for path, subdirs, files in os.walk(args.EnvDefDir) for name in files if name.endswith(".sv")]
    TestFiles       = [os.path.join(path, name) for path, subdirs, files in os.walk(args.TestSVDir) for name in files if name.endswith(".sv")]

    with open(f'{args.RunDir}/lists/rtl_verilog_files.list', 'w') as f:
        for item in RtlVerilogFiles:
            f.write("%s\n" % item)
    # with open(f'{RunDir}/lists/rtl_vhdl_files.list', 'w') as f:
    #     for item in RtlVhdlFiles:
    #         f.write("%s\n" % item)
    with open(f'{args.RunDir}/lists/tb.list', 'w') as f:
        for item in TBFiles:
            f.write("%s\n" % item)
    with open(f'{args.RunDir}/lists/env.list', 'w') as f:
        for item in EnvFiles:
            f.write("%s\n" % item)
    with open(f'{args.RunDir}/lists/test.list', 'w') as f:
        for item in TestFiles:
            f.write("%s\n" % item)
###########################################################

## Copying Params Folder
###########################################################
def copy_params(): 
    os.mkdir(f"{args.RunDir}/params/")
    shutil.copy(f"{args.TestDir}/params/run.do", f"{args.RunDir}/params/")

###########################################################

## Copying Params Folder
###########################################################
def check_error(strval):
    kwords_err = ['** Error:', 'UVM_ERROR', 'Optimization failed', '# Error loading design']
    kwords_warn = ['** Warning:']

    if strval == "comp": 
        file_to_search =  "verilog_comp"
    elif strval == "opt": 
        file_to_search =  "optimization"
    elif strval == "sim":
        file_to_search =  "simulation"

    with open(f"{args.RunDir}/logs/{file_to_search}.log") as f:
        if any(n in f.read() for n in kwords_err):
            throw_err("**************************************")
            throw_err("*************** Failed ***************")
            throw_err("**************************************")
            sys.exit()
        elif any(n in f.read() for n in kwords_warn):
            throw_warning("**************************************")
            throw_warning("********* Done with Warnings *********")
            throw_warning("**************************************")
        else: 
            throw_success("**************************************")
            throw_success("************** Success ***************")
            throw_success("**************************************")

###########################################################


