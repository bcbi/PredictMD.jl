# Requirements for plotting

There are no requirements in order to run PredictMD--you can train, run,
and evaluate models without installing any additional software. However, in
order to generate plots (e.g. ROC curves), you need to install the following
additional software packages on your system:
* LaTeX
* pdf2svg.

See below for instructions on installing these software packages.

Once you have installed the required software, you can test PredictMD's
plotting functionality by running the following command in Julia:
```julia
ENV["PREDICTMD_TEST_GROUP"] = "test-plots"; Pkg.test("PredictMD");
```

## Installing LaTeX

To confirm that LaTeX is installed on your system, open a terminal window and
run the following command:
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
If you receive an error (e.g. "command not found"), download and install a
TeX distribution from the appropriate link below:
* Windows: [https://tug.org/protext/](https://tug.org/protext/)
* macOS: [https://tug.org/mactex/](https://tug.org/mactex/)
* GNU/Linux: [https://tug.org/texlive/](https://tug.org/texlive/)

## Installing pdf2svg

To confirm that pdf2svg is installed on your system, open a terminal window
and run the following command:
```bash
pdf2svg
```

You should see an output message that looks something like this:
```
Usage: pdf2svg <in file.pdf> <out file.svg> [<page no>]
```
If you receive an error (e.g. "command not found"), download and install
pdf2svg from the appropriate link below:
* Windows: [https://github.com/jalios/pdf2svg-windows](
    https://github.com/jalios/pdf2svg-windows)
* macOS: [http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/](
    http://brewinstall.org/Install-pdf2svg-on-Mac-with-Brew/)
* GNU/Linux: [http://www.cityinthesky.co.uk/opensource/pdf2svg/](
    http://www.cityinthesky.co.uk/opensource/pdf2svg/)

