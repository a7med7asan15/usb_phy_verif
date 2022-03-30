import os
import sys
import args 

## Some Checks
###########################################################
def check_path(): 
    if not os.path.isdir(args.RtlDir):
        print('RTL path specified does not exist')
        sys.exit()

    if not os.path.isdir(args.RunDir):
        os.mkdir(args.RunDir)
        os.mkdir(args.RunDir+"/lists")
        os.mkdir(args.RunDir+"/logs")

###########################################################

## Generating lists
###########################################################
def generate_lists():
    os.chdir(args.RunDir)

    RtlVerilogFiles = [os.path.join(path, name) for path, subdirs, files in os.walk(args.RtlDir) for name in files if name.endswith(".v") or name.endswith(".sv")]
    #RtlVhdlFiles    = [os.path.join(path, name) for path, subdirs, files in os.walk(RtlDir) for name in files if name.endswith(".vhd")]
    TBFiles         = [os.path.join(path, name) for path, subdirs, files in os.walk(args.TBDir) for name in files if name.endswith(".sv")]
    EnvFiles        = [os.path.join(path, name) for path, subdirs, files in os.walk(args.EnvDir) for name in files if name.endswith(".sv")]
    TestFiles       = [os.path.join(path, name) for path, subdirs, files in os.walk(args.TestDir) for name in files if name.endswith(".sv")]

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