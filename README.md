# PredictMD - Uniform interface for machine learning in Julia

[PredictMD](https://predictmd.net) is a free and open-source Julia package that provides a uniform interface for machine learning.

PredictMD makes it easy to automate machine learning workflows and create reproducible machine learning pipelines.

It is the official machine learning package of the Brown Center for Biomedical Informatics (BCBI).

<table>
    <tbody>
        <tr>
            <td>Repo Status</td>
            <td>
            <a href="https://www.repostatus.org/#active">
            <img src="https://www.repostatus.org/badges/latest/active.svg"
            alt="Project Status: Active – The project has reached a stable,
            usable state and is being actively developed." /></a></td>
        </tr>
        <tr>
            <td>Travis CI</td>
            <td><a href="https://travis-ci.org/bcbi/PredictMD.jl/branches">
            <img
            src="https://travis-ci.org/bcbi/PredictMD.jl.svg?branch=master"
            /></a></td>
        </tr>
        <tr>
            <td>CodeCov</td>
            <td><a
            href="https://codecov.io/gh/bcbi/PredictMD.jl/branch/master">
            <img
src="https://codecov.io/gh/bcbi/PredictMD.jl/branch/master/graph/badge.svg"
            /></a></td>
        </tr>
        <tr>
            <td>Current Release</td>
            <td>
            <a
            href="https://github.com/bcbi/PredictMD.jl/releases/latest">
        <img src="https://img.shields.io/github/release/bcbi/PredictMD.svg"
            /> </a></td>
        </tr>
        <tr>
            <td>DOI</td>
            <td>
            <a href="https://zenodo.org/badge/latestdoi/109460252">
            <img src="https://zenodo.org/badge/109460252.svg"/></a></td>
        </tr>
        <tr>
            <td>Documentation (Stable)</td>
            <td><a href="https://predictmd.net/stable">
            <img
            src="https://img.shields.io/badge/docs-stable-blue.svg" />
            </a></td>
        </tr>
        <tr>
            <td>Documentation (Dev)</td>
            <td><a
            href="https://predictmd.net/latest">
            <img
            src="https://img.shields.io/badge/docs-dev-blue.svg" />
            </a></td>
        </tr>
    </tbody>
</table>

| Table of Contents |
| ----------------- |
| [1. Installation](#installation) |
| [2. Run the test suite after installing](#run-the-test-suite-after-installing) |
| [3. Docker image](#docker-image) |
| [4. Documentation](#documentation) |
| [5. Citing](#citing) |
| [6. Related Repositories](#related-repositories) |
| [7. Contributing](#contributing) |

## Installation

PredictMD is registered in the Julia General registry. Therefore, to install PredictMD, simply open Julia and run the following three lines:
```julia
import Pkg
Pkg.add("PredictMDFull")
import PredictMDFull
```

## Run the test suite after installing

After you install PredictMD, you should run the test suite to make sure that
everything is working. You can run the test suite by running the following four lines in Julia:
```julia
import Pkg
Pkg.test("PredictMD")
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
```

## Docker image
Alternatively, you can use the PredictMD Docker image for easy installation. Download and start the container by running the following line:
```bash
docker run --name predictmd -it dilumaluthge/predictmd /bin/bash
```

After you have exited the container, you can return to it by running the following line:
```bash
docker start -ai predictmd
```

## Documentation

The [PredictMD documentation](https://predictmd.net/stable) contains
useful information, including instructions for use, example code, and a
description of
PredictMD's internals.

## Citing

If you use PredictMD in research, please cite the software using the following DOI: <a href="https://zenodo.org/badge/latestdoi/109460252"> <img src="https://zenodo.org/badge/109460252.svg"/></a>

## Related Repositories

- [BCBIRegistry](https://github.com/bcbi/BCBIRegistry) - Julia package registry for the Brown Center for Biomedical Informatics (BCBI)
- [ClassImbalance.jl](https://github.com/bcbi/ClassImbalance.jl) - Sampling-based methods for correcting for class imbalance in two-category classification problems
- [OfflineRegistry](https://github.com/DilumAluthge/OfflineRegistry) - Generate a custom Julia package registry, mirror, and depot for use on workstations without internet access
- [PredictMD-docker](https://github.com/DilumAluthge/PredictMD-docker) - Docker and Singularity images for PredictMD
- [PredictMD-roadmap](https://github.com/bcbi/PredictMD-roadmap) - Roadmap for the PredictMD machine learning pipeline
- [PredictMD.jl](https://github.com/bcbi/PredictMD.jl) - Uniform interface for machine learning in Julia
- [PredictMDAPI.jl](https://github.com/bcbi/PredictMDAPI.jl) - Provides the abstract types and generic functions that define the PredictMD application programming interface (API)
- [PredictMDExtra.jl](https://github.com/bcbi/PredictMDExtra.jl) - Install all of the dependencies of PredictMD (but not PredictMD itself)
- [PredictMDFull.jl](https://github.com/bcbi/PredictMDFull.jl) - Install PredictMD and all of its dependencies

## Contributing

If you would like to contribute to the PredictMD source code, please read the instructions in [CONTRIBUTING.md](CONTRIBUTING.md).
