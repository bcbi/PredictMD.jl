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
            <td align="left"><a href="#3-examples">3. Examples</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#4-contributing">4. Contributing</a></td>
        </tr>
    </tbody>
</table>


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
