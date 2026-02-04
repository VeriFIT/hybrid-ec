# hybrid-ec
This is a repository with source codes and experiments for the ICLP'26 paper
"Event Calculus Meets Hybrid ASP" by Vasicek O., Arias J., Fiedor J., Gupta G.,
Krena B., Nemec J., Romero J., and Vojnar T.

This repository is meant as an artifact to support the paper, but also as a 
collection of examples encoded for DEC and HEC to serve as a modeling guide.

## Directory structure
- `utils/`                  -- Utilities (scripts, docker, env)
- `clingo/`                 -- Directory for clingo
- `hybrid-clingo/`          -- Directory for clingcon and clingo-lpx
- both of the above include this sub-structure
  - `axioms/`               -- Encoding of the axioms
  - `examples/exN-*`        -- Directories for our set of examples
  - `examples/exN-*./logs/` -- Execution logs for each example
  - `examples-ec2asp/`      -- Examples from https://azreasoners.github.io/ecasp/ec2asp_linux.htm, modified for current clingo
  - `examples-ec2asp/logs/` -- Execution logs for each example

## Installing the tools
- Use `miniconda` to create python environments using the provided commands in `./makefile`.
- Alternatively, we provide a dockerfile `utils/dockerfile` made for podman  that can be used to run all three tools

## Executing reasoning
- Make sure to activate the right environment, if you are using `miniconda` environments
- Each example has a `makefile` that can be used to execute it or to see how to do it manually
  - Our HEC approach is executed using an incremental python script `hybrid-clingo/hec-incr.py`
  - clingo is executing directly
- Logs were produced on a laptop with a Ryzen 7 1.9Ghz CPU

## Sources
- Encodings of the axioms for clingo are based on the ones provided at http://decreasoner.sourceforge.net/csr/ecasp
  and https://azreasoners.github.io/ecasp/ec2asp_linux.htm
- EC2ASP examples are from https://azreasoners.github.io/ecasp/ec2asp_linux.htm