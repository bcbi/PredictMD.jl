# AluthgeSinhaBase.jl

| Table of Contents                  |
| ---------------------------------- |
| 1. [Build Status](#build-status)   |      
| 2. [Installation](#installation)   |
| 3. [Examples](#examples)           |
| 4. [LaTeX](#latex)                 |
| 5. [pdf2svg](#pdf2svg)             |

## Build Status

<table>
    <thead>
        <tr>
            <th>Branch</th>
            <th>Build Status</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="center">master</td>
            <td align="center"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (master)" title="Build Status (master)" src="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=master"></a></td>
        </tr>
        <tr>
            <td align="center">develop</td>
            <td align="center"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (develop)" title="Build Status (develop)" src="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=develop"></a></td>
        </tr>
        <tr>
            <td align="center" colspan="2"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches">View build status for all branches</a></td>
        </tr>
    <tbody>
</table>

## Installation

#### Step 1: Make sure that your version of Julia is at least 0.6.2
Open a terminal window and run the following command:
```bash
julia -v
```
You should see an output message that looks something like this:
```
julia version 0.6.2
```
If you receive an error (e.g. "command not found"), or if your version of Julia is less than 0.6.2, go to [https://julialang.org/downloads/](https://julialang.org/downloads/) and follow the instructions to install an appropriately recent version of Julia.

#### Step 2: Make sure that LaTex is installed on your system:
Open a terminal window and run the following command:
```bash
latex -v
```
You should see an output message that looks something like this:
```
pdfTeX 3.14159265-2.6-1.40.18 (TeX Live 2017)
kpathsea version 6.2.3
Copyright 2017 Han The Thanh (pdfTeX) et al.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the pdfTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the pdfTeX source.
Primary author of pdfTeX: Han The Thanh (pdfTeX) et al.
Compiled with libpng 1.6.29; using libpng 1.6.29
Compiled with zlib 1.2.11; using zlib 1.2.11
Compiled with xpdf version 3.04
```
If you receive an error (e.g. "command not found"), see the [LaTeX](#latex) section for instructions on installing LaTeX.

#### Step 3: Make sure that pdf2svg is installed on your system:
Open a terminal window and run the following command:
```bash
pdf2svg
```

You should see an output message that looks something like this:
```
Usage: pdf2svg <in file.pdf> <out file.svg> [<page no>]
```
If you receive an error (e.g. "command not found"), see the [pdf2svg](#pdf2svg) section for instructions on installing pdf2svg.

#### Step 4: Update your Julia package directory:
```julia
julia> Pkg.update()
```

#### Step 5: There are three dependencies that need to be installed manually:
```julia
julia> Pkg.clone("https://github.com/dilumaluthge/AUC.jl")
julia> Pkg.clone("https://github.com/dilumaluthge/ClassImbalance.jl")
julia> Pkg.clone("https://github.com/dilumaluthge/RDatasets.jl")
```

#### Step 6: Install AluthgeSinhaBase:
```julia
julia> Pkg.clone("git@github.com:dilumaluthge/AluthgeSinhaBase.jl.git")
```

#### Step 7: Switch to the master branch of AluthgeSinhaBase, which gives you the latest stable version:
```julia
julia> Pkg.checkout("AluthgeSinhaBase", "master")
```

#### Step 8: After switching to the master branch, run Pkg.update() again:
```julia
julia> Pkg.update()
```

#### Step 9: Finally, run the test suite:
```julia
julia> Pkg.test("AluthgeSinhaBase")
```

Once the test suite has passed, you are ready to use AluthgeSinhaBase!

## Examples
The `examples/` folder contains several files that illustrate the usage of AluthgeSinhaBase:

| Filename | Problem type | Problem description | Dataset |
| -------- | ------------ | ------------------- | ------- |
| [`examples/bostonhousing.jl`](https://github.com/dilumaluthge/AluthgeSinhaBase.jl/blob/master/examples/bostonhousing.jl) | Single label regression | Predict the median value of houses | [Boston housing dataset](https://github.com/johnmyleswhite/RDatasets.jl/blob/master/doc/MASS/rst/Boston.rst) |
| [`examples/breastcancerbiopsy.jl`](https://github.com/dilumaluthge/AluthgeSinhaBase.jl/blob/master/examples/breastcancerbiopsy.jl) | Single label binary classification | Classify a tumor as benign or malignant | [Wisconsin breast cancer biopsy dataset](https://github.com/johnmyleswhite/RDatasets.jl/blob/master/doc/MASS/rst/biopsy.rst) |

## LaTeX
AluthgeSinhaBase requires LaTeX for generating plots. If LaTeX is not installed on your system, download and install a TeX distribution from the appropriate link below:
* Windows: [https://www.tug.org/protext/](https://www.tug.org/protext/)
* macOS: [https://www.tug.org/mactex/](https://www.tug.org/mactex/)
* GNU/Linux: [https://www.tug.org/texlive/](https://www.tug.org/texlive/)

## pdf2svg
AluthgeSinhaBase requires pdf2svg for generating SVG images. If pdf2svg is not installed on your system, download and install it from the appropriate link below:
* Windows: [https://github.com/jalios/pdf2svg-windows](https://github.com/jalios/pdf2svg-windows)
* macOS: [http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/](http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/)
* GNU/Linux: [https://github.com/dawbarton/pdf2svg](https://github.com/dawbarton/pdf2svg)
