# AluthgeSinhaBase.jl

| Table of Contents                  |
| ---------------------------------- |
| 1. [Build Status](#build-status)   |      
| 2. [Installation](#installation)   |
| 3. [LaTeX](#latex)                 |
| 4. [pdf2svg](#pdf2svg)             |

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

#### Step 1: Make sure that LaTex is installed on your system:
Open a shell and run the following command:
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

#### Step 2: Make sure that pdf2svg is installed on your system:
Open a shell and run the following command:
```bash
pdf2svg
```

You should see an output message that looks something like this:
```
Usage: pdf2svg <in file.pdf> <out file.svg> [<page no>]
```
If you receive an error (e.g. "command not found"), see the [pdf2svg](#pdf2svg) section for instructions on installing pdf2svg.

#### Step 3: Update your Julia package directory:
```julia
julia> Pkg.update()
```

#### Step 4: There are three dependencies that need to be installed manually:
```julia
julia> Pkg.clone("https://github.com/dilumaluthge/AUC.jl")
julia> Pkg.clone("https://github.com/dilumaluthge/ClassImbalance.jl")
julia> Pkg.clone("https://github.com/dilumaluthge/RDatasets.jl")
```

#### Step 5: Install AluthgeSinhaBase:
```julia
julia> Pkg.clone("git@github.com:dilumaluthge/AluthgeSinhaBase.jl.git")
```

#### Step 6: Checkout the master branch of AluthgeSinhaBase, which gives you the latest stable version:
```julia
julia> Pkg.checkout("AluthgeSinhaBase", "master")
```

#### Step 7: Run the test suite:
```julia
julia> Pkg.test("AluthgeSinhaBase")
```

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
