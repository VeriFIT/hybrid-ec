import subprocess
import re
import argparse
import os
from enum import Enum

class ExitCode(Enum):
	E_UNKNOWN   = 0   #  Satisfiability of problem not known; search not started.   
	E_INTERRUPT = 1   #  Run was interrupted.                                      
	E_SAT       = 10  #  At least one model was found.                             
	E_EXHAUST   = 20  #  Search-space was completely examined.                     
	E_MEMORY    = 33  #  Run was interrupted by out of memory exception.           
	E_ERROR     = 65  #  Run was interrupted by internal error.                    
	E_NO_RUN    = 128 #  Search not started because of syntax or command line error.


def decode_exit_code(code):
    def extract_flag(flag, code, res):
        if (code - flag.value >= 0):
            res.append(flag)
            return code - flag.value
        else:
            return code
        
    if (code == ExitCode.E_UNKNOWN):
        return [ExitCode.E_UNKNOWN]
    
    res = []
    code = extract_flag(ExitCode.E_NO_RUN, code, res)
    code = extract_flag(ExitCode.E_ERROR, code, res)
    code = extract_flag(ExitCode.E_MEMORY, code, res)
    code = extract_flag(ExitCode.E_EXHAUST, code, res)
    code = extract_flag(ExitCode.E_SAT, code, res)
    code = extract_flag(ExitCode.E_INTERRUPT, code, res)
    return res

def parse_assignment(line):
    """
    Parses:
      (time,1)=10 (time,2)=25 ...
    into:
      { "(time,1)": "10", "(time,2)": "25", ... }
    """
    assignments = {}
    pattern = re.compile(r'(\([^=]+\))=([^ ]+)')
    for atom, value in pattern.findall(line):
        assignments[atom] = value
    return assignments

def replace_theory_atoms(model_line, assignments):
    """
    Replaces occurrences of theory atoms in model_line
    using the assignments dictionary.
    """
    for key, val in assignments.items():
        if(conf_args.r == True and '/' in val):
            rat = val.split('/')
            val = float(rat[0]) / float(rat[1])
        if (conf_args.replace_assign == 1):
            model_line = model_line.replace(key, '(' + key + '=' + str(val) + ')')
        elif (conf_args.replace_assign == 2):
            model_line = model_line.replace(key, str(val))
    return model_line

def replace_basic_intervals(model_line):
    """
    Replaces occurrences of
        ,"< T =<",
        with
        < T =<
        and more
    """
    model_line = model_line.replace(',"< ', '<')
    model_line = model_line.replace(' =<",', '=<')
    model_line = model_line.replace(',"->",', '->')
    model_line = model_line.replace('," = ",', '=')
    return model_line

def add_newlines(model_line):
    model_line = model_line.replace(') ', ')\n')
    return model_line

def check_output_without_exit_code(text):
    lines = text.splitlines()

    if (len(lines) < 3):
        return ExitCode.E_ERROR.value
    
    line = lines[3]
    if (line == "UNSATISFIABLE"):
        return ExitCode.E_EXHAUST.value
    elif (re.match("Answer:.*", line)):
        return ExitCode.E_SAT.value
    else:
        return ExitCode.E_ERROR.value

def process_clingcon_output(text):
    lines = text.splitlines()
    i = 0
    output = []

    while i < len(lines):
        line = lines[i]

        if line.startswith("Answer:"):
            output.append(line)            # keep "Answer: n"
            model_line = lines[i + 1]       # predicates
            assignment_line = lines[i + 3]  # assignment values

            assignments = parse_assignment(assignment_line)
            model_line = replace_basic_intervals(model_line)
            if (conf_args.replace_assign > 0 and conf_args.debug == False):
                model_line = replace_theory_atoms(model_line, assignments)
            if (conf_args.no_newlines == False):
                model_line = add_newlines(model_line)

            output.append(model_line)
            output.append("Assignment:")
            output.append(assignment_line)

            i += 4
        else:
            output.append(line)
            i += 1

    return "\n".join(output)


conf_args = []

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description='Execute HEC incrementally until the right number of steps is found.')
    
    parser.add_argument('-c', action='append', help='specify a constant for the solver in the form of "-c name=vale"')
    parser.add_argument('--maxtime', type=int, help='upper limit for the timescale')
    parser.add_argument('--minstep', type=int, default=1, help='number of steps to start at')
    parser.add_argument('--maxstep', type=int, default=100, help='number of steps to end')
    parser.add_argument('--replace_assign', type=int, default=2, help='set the level of replacement of theory atom assignments in the model (zero is off)')
    parser.add_argument('--no_newlines', action='store_true', help='disable adding new lines into models')
    parser.add_argument('--project', action='store_true', help='--project for the solver')
    parser.add_argument('--con', action='store_true', help='execute clingcon instad of clingolpx')
    parser.add_argument('-r', action='store_true', help='output rational numbers as real numbers in the model (only if --replace_assign is not zero)')
    parser.add_argument('-n', type=int, default=10, help='-n parameter to be passed to the solver')
    parser.add_argument('--keep_going', action='store_true', help='keep looking for more solutions with more steps even after a solution was found')
    parser.add_argument('--no_last_step', action='store_true', help='disables the implicit last step, allowing easier reasoning about circular or zeno behavior')
    parser.add_argument('--no_signifstep', action='store_true', help='disable the significant step constraint')
    parser.add_argument('--no_axioms', action='store_true', help='disable automatic inclusion of hec.pl and hec-show.pl')
    parser.add_argument('--debug', action='store_true', help='enable debug prints instead of fancy show')
    parser.add_argument('source_files', nargs='*', help='any number of source files')
    conf_args = parser.parse_args()
    
    
    scriptdir = os.path.dirname(__file__)
    scriptdir=os.path.abspath(scriptdir)
    axioms = os.path.join(scriptdir, 'axioms/hec.lp'),
    axioms_show = os.path.join(scriptdir, 'axioms/hec-show.lp'),
    
    
    steps=conf_args.minstep
    

    print("Looking for the right number of steps: ", end='', flush=True)
    while (steps <= conf_args.maxstep):
        print(str(steps) + " ", end='', flush=True)
        
        cmd = []   
        if(conf_args.con == True):
            cmd.extend([
                "python", "-m", "clingcon", "--enable-python",
                os.path.join(scriptdir, 'axioms/hec-memb-con.lp')
            ])
        else:
            cmd.extend([
                "python", "-c", "import clingolpx; clingolpx._pyclingolpx()", "--strict", "--project-anonymous",
                os.path.join(scriptdir, 'axioms/hec-memb-lpx.lp')
            ])
            
        if(conf_args.project == True):
            cmd.append("--project")
            
        if(conf_args.maxtime != None):
            cmd.extend([
                "-c",
                "maxtime=" + str(conf_args.maxtime)
            ])
        
        if(conf_args.no_last_step == True):
            cmd.extend([
                "-c",
                "disablelaststep=" + str(1)
            ])
        if(conf_args.no_signifstep == True):
            cmd.extend([
                "-c",
                "disablesignificantconstr=" + str(1)
            ])
        if(conf_args.debug == True):
            cmd.extend([
                "-c",
                "debugprints=" + str(1)
            ])
        if(conf_args.c != None):
            for c in conf_args.c:    
                cmd.extend([
                    "-c",
                    str(c)
                ])
            
        cmd.extend([
            "-n",
            str(conf_args.n),
            "-c",
            "maxstep=" + str(steps),
        ])
        
        if(conf_args.no_axioms == False):
            cmd.extend([
                os.path.join(scriptdir, 'axioms/hec.lp'),
                os.path.join(scriptdir, 'axioms/hec-show.lp')
            ])
            
        cmd.extend(conf_args.source_files,)
        
        #print(cmd)
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True
        )
        
        #returncode = result.returncode
        returncode = check_output_without_exit_code(result.stdout) # temporary workaround to check the result while we cant get return code from lpx
        
        decoded_exit = decode_exit_code(returncode)
        if (ExitCode.E_SAT in decoded_exit):
            print("FOUND")
            print(process_clingcon_output(result.stdout))        
            print(result.stderr)
            if (conf_args.keep_going == False):
                exit(result.returncode)
            else:
                print("Looking for more solutions with more steps: ", end='', flush=True)
                steps = steps + 1
            
        elif (ExitCode.E_EXHAUST not in decoded_exit):
            print("ERROR")
            print(result.stdout)
            print(result.stderr)
            exit(result.returncode)
            
        else:
            steps = steps + 1
            #print(result.stdout)
            
    print("MAXSTEP_REACHED")
    

