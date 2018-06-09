# [PredictMD](https://www.predictmd.net) - Uniform interface for machine learning in Julia

## Current release: <a href="https://github.com/bcbi/PredictMD.jl/releases/latest"><img alt="Current release" title="Current release" src="https://img.shields.io/github/release/bcbi/PredictMD.svg"></a>

<table>
    <thead>
        <tr>
            <th>Branch</th>
            <th>Description</th>
            <th>Docs</th>
            <th>Travis</th>
            <th>AppVeyor</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>master</td>
            <td>Current release (stable)</td>
            <td><a href="https://www.predictmd.net/stable"><img alt="Documentation (stable)" title="Documentation (stable)" src="https://img.shields.io/badge/docs-stable-blue.svg"></a></td>
            <td><a href="https://travis-ci.org/bcbi/PredictMD.jl/branches"><img alt="Travis build status (master)" title="Travis build status (master)" src="https://travis-ci.org/bcbi/PredictMD.jl.svg?branch=master"></a></td>
            <td><a href="https://ci.appveyor.com/project/mirestrepo/predictmd-jl/history"><img alt="AppVeyor build status (master)" title="AppVeyor build status (master)" src="https://ci.appveyor.com/api/projects/status/github/bcbi/PredictMD.jl?branch=master&svg=true"></a></td>
        </tr>
        <tr>
            <td>develop</td>
            <td>Development branch (latest)</td>
            <td><a href="https://www.predictmd.net/latest"><img alt="Documentation (latest)" title="Documentation (latest)" src="https://img.shields.io/badge/docs-latest-blue.svg"></a></td>
            <td><a href="https://travis-ci.org/bcbi/PredictMD.jl/branches"><img alt="Travis build status (develop)" title="Travis build status (develop)" src="https://travis-ci.org/bcbi/PredictMD.jl.svg?branch=develop"></a></td>
            <td><a href="https://ci.appveyor.com/project/mirestrepo/predictmd-jl/history"><img alt="AppVeyor build status (develop)" title="AppVeyor build status (develop)" src="https://ci.appveyor.com/api/projects/status/github/bcbi/PredictMD.jl?branch=develop&svg=true"></a></td>
        </tr>
    </tbody>
</table>

[PredictMD](https://www.predictmd.net) is a Julia package that provides a uniform interface for using multiple different statistics and machine learning packages.

## Installation

To install PredictMD, open Julia (e.g. open a terminal, type `julia`, and press enter) and run the following command:
```julia
Pkg.clone("https://github.com/bcbi/PredictMD.jl")
```

After you install PredictMD, you should run the test suite to make sure that everything is working. You can run the test suite with the following Julia command:
```julia
Pkg.test("PredictMD")
```

## Documentation

The [PredictMD documentation](https://www.predictmd.net/stable) contains useful
information, including instructions for use, example code, and a description of
PredictMD's internals.

