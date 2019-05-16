<!-- Beginning of file -->

# PredictMD - Uniform interface for machine learning in Julia

# Website: [https://predictmd.net](https://predictmd.net)

<a href="https://github.com/bcbi/PredictMD.jl/releases/latest"><img src="https://img.shields.io/github/release/bcbi/PredictMD.svg" /> </a> <a href="https://zenodo.org/badge/latestdoi/109460252"> <img src="https://zenodo.org/badge/109460252.svg"/></a>

[PredictMD](https://predictmd.net) is a free and open-source Julia package that provides a uniform interface for machine learning.

| Table of Contents |
| ----------------- |
| [1. Installation](#installation) |
| [2. Documentation](#documentation) |
| [3. Citing](#citing) |
| [4. Related Repositories](#related-repositories) |
| [5. Contributing](#contributing) |
| [6. Repository Status](#repository-status) |
| [7. CI/CD](#cicd) |

## Installation

PredictMD requires Julia version 1.1 or greater.

### macOS and GNU/Linux

Open a new terminal and run the following line:
```bash
 curl https://predictmd.net/install.jl | julia 
```

### Windows and all other platforms

Step 1: Download the following file and save it to your computer: [https://predictmd.net/install.jl](https://predictmd.net/install.jl)

Step 2: Navigate to the location of the file saved in step 1, and run the file with Julia, for example:
```bash
julia install.jl
```

### Run the test suite after installing

After you install PredictMD, you should run the test suite to make sure that
everything is working. You can run the test suite with the following
Julia command:
```julia
Pkg.test("PredictMD")
```

## Documentation

The [PredictMD documentation](https://predictmd.net/stable) contains
useful information, including instructions for use, example code, and a
description of
PredictMD's internals.

## Citing

If you use PredictMD in research, please cite the software using the following DOI: <a href="https://zenodo.org/badge/latestdoi/109460252"> <img src="https://zenodo.org/badge/109460252.svg"/></a>

## Related Repositories

- [bcbi/PredictMDFull.jl](https://github.com/bcbi/PredictMDFull.jl) - Install PredictMD and all of its Julia dependencies
- [bcbi/PredictMDExtra.jl](https://github.com/bcbi/PredictMDExtra.jl) - Install all of the Julia dependencies of PredictMD (but does not install PredictMD)
- [DilumAluthge/PredictMD-docker](https://github.com/DilumAluthge/PredictMD-docker) - Generate a custom Julia package registry, mirror, and depot for use on workstations without internet access
- [bcbi/BCBIRegistry](https://github.com/bcbi/BCBIRegistry) - Julia package registry for PredictMD.jl and related packages
- [DilumAluthge/OfflineRegistry](https://github.com/DilumAluthge/OfflineRegistry) - Generate a custom Julia package registry, mirror, and depot for use on workstations without internet access

## Contributing

If you would like to contribute to the PredictMD source code, please read the instructions in [CONTRIBUTING.md](CONTRIBUTING.md).

## Repository Status

<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg" alt="Project Status: Active – The project has reached a stable, usable state and is being actively developed." /></a>

## CI/CD

<table>
    <thead>
        <tr>
            <th></th>
            <th>master (stable)</th>
            <th>develop (latest/unstable)</th>
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
            <td><a href="https://predictmd.net/stable">
            <img
            src="https://img.shields.io/badge/docs-stable-blue.svg" />
            </a>
            </td>
            <td>
            <a
            href="https://predictmd.net/latest">
            <img
            src="https://img.shields.io/badge/docs-latest-blue.svg" />
            </a>
            </td>
        </tr>
    </tbody>
</table>

<!-- End of file -->
