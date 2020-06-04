# PredictMD - Uniform interface for machine learning in Julia

[![Zenodo][zenodo-img]][zenodo-url]

[![Documentation (stable)][docs-stable-img]][docs-stable-url]
[![Documentation (development)][docs-development-img]][docs-development-url]

[![PkgEval][pkgeval-img]][pkgeval-url]
[![Continuous integration (CI)][ghactions-ci-img]][ghactions-ci-url]
[![Code coverage][codecov-img]][codecov-url]

[zenodo-img]: https://zenodo.org/badge/109460252.svg
[zenodo-url]: https://doi.org/10.5281/zenodo.1291209
[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://predictmd.net/stable
[docs-development-img]: https://img.shields.io/badge/docs-development-blue.svg
[docs-development-url]: https://predictmd.net/development

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/P/PredictMD.named.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/P/PredictMD.html
[ghactions-ci-img]: https://github.com/bcbi/PredictMD.jl/workflows/CI/badge.svg?branch=master
[ghactions-ci-url]: https://github.com/bcbi/PredictMD.jl/actions?query=workflow%3ACI+branch%3Amaster
[codecov-img]: https://codecov.io/gh/bcbi/PredictMD.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/bcbi/PredictMD.jl/branch/master

[PredictMD](https://predictmd.net) is a free and open-source Julia package that provides a uniform interface for machine learning.

PredictMD makes it easy to automate machine learning workflows and create reproducible machine learning pipelines.

It is the official machine learning framework of the [Brown Center for Biomedical Informatics](https://github.com/bcbi).

| Table of Contents |
| ----------------- |
| [1. Installation](#installation) |
| [2. Run the test suite after installing](#run-the-test-suite-after-installing) |
| [3. Citing](#citing) |
| [4. Docker image](#docker-image) |
| [5. Documentation](#documentation) |
| [6. Related Repositories](#related-repositories) |
| [7. Contributing](#contributing) |

## Installation

PredictMD is registered in the Julia General registry. Therefore, to install PredictMD, simply open Julia and run the following four lines:
```julia
import Pkg
Pkg.activate("PredictMDEnvironment"; shared = true)
Pkg.add("PredictMDFull")
import PredictMDFull
```

## Run the test suite after installing

After you install PredictMD, you should run the test suite to make sure that
everything is working. You can run the test suite by running the following five lines in Julia:
```julia
import Pkg
Pkg.activate("PredictMDEnvironment"; shared = true)
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
Pkg.test("PredictMD")
```

## Citing

If you use PredictMD in research, please
cite the software using the following DOI:
<a href="https://doi.org/10.5281/zenodo.1291209">
<img
src="https://zenodo.org/badge/109460252.svg"/>
</a>


## Docker image
Alternatively, you can use the PredictMD Docker image for easy installation. Download and start the container by running the following line:
```bash
docker run --name predictmd -it dilumaluthge/predictmd /bin/bash
```

Once you are inside the container, you can start Julia by running the following line:
```bash
julia
```

In Julia, run the following line to load PredictMD:
```julia
import PredictMDFull
```

You can run the test suite by running the following four lines in Julia:
```julia
import Pkg
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
Pkg.test("PredictMD")
```

After you have exited the container, you can return to it by running the following line:
```bash
docker start -ai predictmd
```

To delete your container, run the following line:
```bash
docker container rm -f predictmd
```

To also delete the downloaded image, run the following line:
```bash
docker image rm -f dilumaluthge/predictmd
```

## Documentation

The [PredictMD documentation](https://predictmd.net/stable) contains
useful information, including instructions for use, example code, and a
description of
PredictMD's internals.

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
- [PredictMDSanitizer.jl](https://github.com/bcbi/PredictMDSanitizer.jl) - Remove potentially sensitive data from trained machine learning models

## Contributing

If you would like to contribute to the PredictMD source code, please read the instructions in [CONTRIBUTING.md](CONTRIBUTING.md).

## Acknowledgements

- This work was supported in part by National Institutes of Health grants U54GM115677, R01LM011963, and R25MH116440. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.
- PredictMD was created by [Dilum P. Aluthge](https://aluthge.com) and Ishan Sinha.
