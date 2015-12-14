Please read the report.pdf associated with the project.

The code is separated in 3 files:

1. pproc.m
2. quickStressEval.m
3. createAnsysIn.m

## Requirements

The code is written in MATLAB to write an input file for ANSYS Parametric Design Language (APDL). Therefore, a license for both applications is required.

## Instructions

### Pre-processing
1. Modify 'ansys_path' and 'work_dir' in pproc.m.
2. Define geometry and boundary conditions. Currently an aluminum pinned-pinned beam.
3. Define 'Location of Loads'. Currently, solve for a force at each boundary node.
4. Run pproc.m

### Quick Stress Evaluation
1. Use same 'project_name' used in pproc.m
2. Define load values and locations. Current set-up is the test case defined in the report
3. Run quickStressEval.m
