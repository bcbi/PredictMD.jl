##### Beginning of file

# Parts of this file are based on:
# 1. https://github.com/KristofferC/PGFPlotsX.jl/blob/master/deps/build.jl

srand(999)

have_lualatex = try success(`lualatex -v`); catch; false; end
if have_lualatex
    info(string("SUCCESS: Found lualatex."))
else
    warn(string("FAILURE: Did not find lualatex."))
end

have_pdflatex = try success(`pdflatex -v`); catch; false; end
if have_pdflatex
    info(string("SUCCESS: Found pdflatex."))
else
    warn(string("FAILURE: Did not find pdflatex."))
end

default_engine = ""
if have_lualatex
    default_engine = "LUALATEX"
elseif have_pdflatex
    default_engine = "PDFLATEX"
else
    warn(
        string(
            "No LaTeX installation found, ",
            "figures will not be generated. ",
            "Make sure either pdflatex or lualatex are installed ",
            "and that the correct paths are set ",
            "then run Pkg.build(\"PredictMD\")",
            )
        )
end

have_pdftoppm =  try success(`pdftoppm  -v`); catch; false; end
if have_pdftoppm
    info(string("SUCCESS: Found pdftoppm."))
else
    warn(string("FAILURE: Did not find pdftoppm."))
end

if !have_pdftoppm
    warn(
        string(
            "Did not find `pdftoppm`, ",
            "png output will be disabled. ",
            "Install `pdftoppm` and run ",
            "Pkg.build(\"PredictMD\") ",
            "to enable.",
        )
        )
end

pdfpath = joinpath(@__DIR__, "pdf2svg-example-file.pdf")
svgpath = joinpath(@__DIR__, "pdf2svg-example-file.svg")
have_pdf2svg = try success(`pdf2svg $pdfpath $svgpath`); catch; false; end
if have_pdf2svg
    info(string("SUCCESS: Found pdf2svg."))
else
    warn(string("FAILURE: Did not find pdf2svg."))
end

if !have_pdf2svg
    warn(
        string(
            "Did not find `pdf2svg`, ",
            "svg output will be disabled. ",
            "Install `pdf2svg` and run ",
            "Pkg.build(\"PredictMD\")",
            "to enable.",
        )
        )
end

if !have_pdf2svg && !have_pdftoppm
    warn(
        string(
            "Found neither pdf2svg or pdftoppm, ",
            "figures will not be viewable in ",
            "IJulia/Jupyter notebooks.",
            )
        )
end

line_1_default_engine = string(
    "DEFAULT_ENGINE = \"",
    default_engine,
    "\"",
    )
line_2_have_pdftoppm = string(
    "HAVE_PDFTOPPM = ",
    have_pdftoppm,
    )
line_3_have_pdftosvg = string(
    "HAVE_PDFTOSVG = ",
    have_pdf2svg,
    )
info(line_1_default_engine)
info(line_2_have_pdftoppm)
info(line_3_have_pdftosvg)
open(joinpath(@__DIR__, "deps.jl"), "w") do f
    println(f, line_1_default_engine)
    println(f, line_2_have_pdftoppm)
    println(f, line_3_have_pdftosvg)
end

const PREAMBLE_PATH = joinpath(@__DIR__, "custom_preamble.tex")
if !isfile(PREAMBLE_PATH)
    touch(PREAMBLE_PATH)
end

##### End of file
