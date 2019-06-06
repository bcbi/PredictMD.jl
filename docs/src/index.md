<!-- Beginning of file -->

# PredictMD

[PredictMD](https://predictmd.net) is a free and open-source Julia package that provides a uniform
interface for machine learning.

PredictMD makes it easy to automate machine learning workflows and
create reproducible machine learning pipelines.

## Installation

PredictMD is registered in the Julia General registry. Therefore, to install PredictMD, simply open Julia and run the following three lines:
```julia
import Pkg
Pkg.add("PredictMDFull")
import PredictMDFull
```

## Running the package tests

You can run the PredictMD test suite by running the
following four lines in Julia:
```julia
import Pkg
Pkg.test("PredictMD")
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
```

<!-- End of file -->
