# PredictMD

[PredictMD](https://predictmd.net) is a free and open-source Julia package that provides a uniform
interface for machine learning.

PredictMD makes it easy to automate machine learning workflows and
create reproducible machine learning pipelines.

## Installation

PredictMD is registered in the Julia General registry. Therefore, to install PredictMD, simply open Julia and run the following four lines:
```julia
import Pkg
Pkg.activate("PredictMDEnvironment"; shared = true)
Pkg.add("PredictMDFull")
import PredictMDFull
```

## Running the package tests

You can run the default PredictMD test suite by running the
following five lines in Julia:
```julia
import Pkg
Pkg.activate("PredictMDEnvironment"; shared = true)
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
Pkg.test("PredictMD")
```

To run the full test suite, which includes
tests of the plotting functionality, run the following six
lines in Julia:
```julia
import Pkg
Pkg.activate("PredictMDEnvironment"; shared = true)
ENV["PREDICTMD_TEST_GROUP"] = "all"
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
Pkg.test("PredictMD")
```
