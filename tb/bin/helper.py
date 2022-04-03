import os
import sys
import args 
import shutil

## Some Checks
###########################################################
def throw_err(err): 
    print(args.BRED + f"Error: {err}" + args.TEND)
    sys.exit()

def check_test(): 
    if args.TestName: 
        print(args.TestName)
    else: 
        if args.SimpleTB: 
            print(args.SimpleTB)
        else: 
            throw_err("No test specified")


def check_path(): 
    if not os.path.isdir(args.RtlDir):
        throw_err("RTL path specified does not exist")

    if not os.path.isdir(args.RunDir):
        if args.sim_only:
            throw_err("Simulation Directory does not exist")    
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
    shutil.copytree(f"{args.TestDir}/params", f"{args.RunDir}/params")



###########################################################

