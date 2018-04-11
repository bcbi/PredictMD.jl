# AluthgeSinhaBase.jl

<table>
    <thead>
        <tr>
            <th>master</th>
            <th>develop</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="https://travis-ci.com/DilumAluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (master)" title="Build Status (master)" src="https://travis-ci.com/DilumAluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=master"></a></td>
            <td><a href="https://travis-ci.com/DilumAluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (develop)" title="Build Status (develop)" src="https://travis-ci.com/DilumAluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=develop"></a></td>
        </tr>
    </tbody>
</table>

AluthgeSinhaBase is a [Julia](https://julialang.org/) package that provides a uniform interface for using multiple different statistics and machine learning packages. This document describes how to install and use AluthgeSinhaBase.

<table>
    <thead>
        <tr>
            <th>Table of Contents</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left"><a href="#1-prerequisites">1. Prerequisites</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#2-installation">2. Installation</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#3-examples">3. Examples</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#4-contributing">4. Contributing</a></td>
        </tr>
    </tbody>
</table>

## 1. Prerequisites

In order to run AluthgeSinhaBase, you need to have all of the following software packages installed on your system:
* Julia (version >= 0.6)
* LaTeX
* pdf2svg.

### 1.1. Julia

In order to check your installed version of Julia, start a new Julia session (e.g. open a terminal window, type ```julia```, and press enter). You should see a welcome message that looks something like this:
```
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: https://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.6.2 (2017-12-13 18:08 UTC)
 _/ |\__'_|_|_|\__'_|  |  Official http://julialang.org/ release
|__/                   |  x86_64-apple-darwin14.5.0
```
If you receive an error (e.g. "command not found"), or if your version of Julia is less than 0.6, go to [https://julialang.org/downloads/](https://julialang.org/downloads/) and follow the instructions to install an appropriately recent version of Julia.

### 1.2. LaTeX

To confirm that LaTeX is installed on your system, open a terminal window and run the following command:
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
If you receive an error (e.g. "command not found"), download and install a TeX distribution from the appropriate link below:
* Windows: [https://www.tug.org/protext/](https://www.tug.org/protext/)
* macOS: [https://www.tug.org/mactex/](https://www.tug.org/mactex/)
* GNU/Linux: [https://www.tug.org/texlive/](https://www.tug.org/texlive/)

### 1.3. pdf2svg

To confirm that pdf2svg is installed on your system, open a terminal window and run the following command:
```bash
pdf2svg
```

You should see an output message that looks something like this:
```
Usage: pdf2svg <in file.pdf> <out file.svg> [<page no>]
```
If you receive an error (e.g. "command not found"), download and install pdf2svg from the appropriate link below:
* Windows: [https://github.com/jalios/pdf2svg-windows](https://github.com/jalios/pdf2svg-windows)
* macOS: [http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/](http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/)
* GNU/Linux: [https://github.com/dawbarton/pdf2svg](https://github.com/dawbarton/pdf2svg)

## 2. Installation



## 3. Examples
The `examples/` folder contains several files that illustrate the usage of AluthgeSinhaBase:

### 3.1. Machine Learning Examples

<table>
    <thead>
        <tr>
            <th>Filename</th>
            <th>Problem type</th>
            <th>Problem description</th>
            <th>Dataset</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left"><a href="examples/bostonhousing.jl">examples/bostonhousing.jl</a></td>
            <td align="left">Single label regression</td>
            <td align="left">Predict the median value of houses</td>
            <td align="left"><a href="https://github.com/johnmyleswhite/RDatasets.jl/blob/master/doc/MASS/rst/Boston.rst">Boston housing dataset</a></td>
        </tr>
        <tr>
            <td align="left"><a href="examples/breastcancerbiopsy.jl">examples/breastcancerbiopsy.jl</a></td>
            <td align="left">Single label binary classification</td>
            <td align="left">Classify a tumor as benign or malignant</td>
            <td align="left"><a href="https://github.com/johnmyleswhite/RDatasets.jl/blob/master/doc/MASS/rst/biopsy.rst">Wisconsin breast cancer biopsy dataset</a></td>
        </tr>
    <tbody>
</table>

## 4. Contributing

If you would like to contribute to the AluthgeSinhaBase source code, please see [CONTRIBUTING.md](CONTRIBUTING.md).
