<!-- Beginning of file -->

# PredictMD - Uniform interface for machine learning in Julia

# Website: [https://www.predictmd.net](https://www.predictmd.net)

<a href="https://github.com/bcbi/PredictMD.jl/releases/latest"><img src="https://img.shields.io/github/release/bcbi/PredictMD.svg" /> </a> <a href="https://zenodo.org/badge/latestdoi/109460252"> <img src="https://zenodo.org/badge/109460252.svg"/></a>

[PredictMD](https://www.predictmd.net) is a free and open-source Julia package that provides a uniform interface for machine learning.

To install PredictMD, open Julia
(e.g. open a terminal, type `julia`, and press enter)
and run the following command:
```julia
Pkg.clone("https://github.com/bcbi/PredictMD.jl")
```

Please submit any issues related to PredictMD to the issue tracker: [https://github.com/bcbi/PredictMD.jl/issues](https://github.com/bcbi/PredictMD.jl/issues)

| Table of Contents |
| ----------------- |
| [1. Installation](#installation) |
| [2. Documentation](#documentation) |
| [3. Citing](#citing) |
| [4. Related Repositories](#related-repositories) |
| [5. Contributing](#contributing) |
| [6. Stronghold](#stronghold) |
| [7. Repository Status](#repository-status) |
| [8. CI/CD](#cicd) |

## Installation

PredictMD requires Julia version 0.7.

To install PredictMD, open Julia
(e.g. open a terminal, type `julia`, and press enter)
and run the following command:
```julia
Pkg.clone("https://github.com/bcbi/PredictMD.jl")
```

After you install PredictMD, you should run the test suite to make sure that
everything is working. You can run the test suite with the following
Julia command:
```julia
Pkg.test("PredictMD")
```

## Documentation

The [PredictMD documentation](https://www.predictmd.net/stable) contains
useful information, including instructions for use, example code, and a
description of
PredictMD's internals.

## Citing

If you use PredictMD in research, please cite the software using the following DOI: <a href="https://zenodo.org/badge/latestdoi/109460252"> <img src="https://zenodo.org/badge/109460252.svg"/></a>

## Related Repositories

- [bcbi/PredictMDFull.jl](https://github.com/bcbi/PredictMDFull.jl) - Install PredictMD and all of its Julia dependencies
- [bcbi/PredictMDExtra.jl](https://github.com/bcbi/PredictMDExtra.jl) - Install all of the Julia dependencies of PredictMD (but does not install PredictMD)
- [bcbi/predictmd-conda-recipes](https://github.com/bcbi/predictmd-conda-recipes) - Conda recipes for building the binary dependencies that are required for plotting in PredictMD

## Contributing

If you would like to contribute to the PredictMD source code, please read the instructions in [CONTRIBUTING.md](CONTRIBUTING.md).

## Stronghold

If you are using PredictMD inside the Stronghold secure computing environment, please read the instructions in [STRONGHOLD.md](STRONGHOLD.md).

## Repository Status

<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg" alt="Project Status: Active – The project has reached a stable, usable state and is being actively developed." /></a>

## CI/CD

<table>
    <thead>
        <tr>
            <th></th>
            <th>master (stable)</th>
            <th>develop (latest)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Travis CI</td>
            <td><a href="https://travis-ci.org/bcbi/PredictMD.jl/branches">
            <img
            src="https://travis-ci.org/bcbi/PredictMD.jl.svg?branch=master"
            /></a></td>
            <td><a href="https://travis-ci.org/bcbi/PredictMD.jl/branches">
            <img
            src="https://travis-ci.org/bcbi/PredictMD.jl.svg?branch=develop"
            /></a></td>
        </tr>
        <tr>
            <td>AppVeyor CI</td>
            <td>
            <a
            href="https://ci.appveyor.com/project/mirestrepo/predictmd-jl/history">
            <img
            title="AppVeyor build status (master)" src="https://ci.appveyor.com/api/projects/status/github/bcbi/PredictMD.jl?branch=master&svg=true"
            />
            </a></td>
            <td><a href="https://ci.appveyor.com/project/mirestrepo/predictmd-jl/history">
            <img
            src="https://ci.appveyor.com/api/projects/status/github/bcbi/PredictMD.jl?branch=develop&svg=true"
            />
            </a></td>
        </tr>
        <tr>
            <td>CodeCov</td>
            <td>
            <a
            href="https://codecov.io/gh/bcbi/PredictMD.jl/branch/master">
            <img
            src="https://codecov.io/gh/bcbi/PredictMD.jl/branch/master/graph/badge.svg"
            /></a></td>
            <td>
            <a
            href="https://codecov.io/gh/bcbi/PredictMD.jl/branch/develop">
            <img src="https://codecov.io/gh/bcbi/PredictMD.jl/branch/develop/graph/badge.svg"
            /></a></td>
        </tr>
        <tr>
            <td>docs</td>
            <td><a href="https://www.predictmd.net/stable">
            <img
            src="https://img.shields.io/badge/docs-stable-blue.svg" />
            </a>
            </td>
            <td>
            <a
            href="https://www.predictmd.net/latest">
            <img
            src="https://img.shields.io/badge/docs-latest-blue.svg" />
            </a>
            </td>
        </tr>
    </tbody>
</table>

<!-- End of file -->
