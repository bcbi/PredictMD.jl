import LaTeXStrings
import PGFPlots
import StatsBase
import ValueHistories

function plotlearningcurve(
        inputobject::AbstractObject,
        curvetype::Symbol = :lossvsiteration;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        )
    inputobjectvaluehistories = valuehistories(inputobject)
    result = plotlearningcurve(
        inputobjectvaluehistories,
        curvetype,
        window = window,
        legendPos = legendPos,
        sampleevery = sampleevery,
        )
    return result
end

function plotlearningcurve(
        inputvaluehistories::ValueHistories.MultivalueHistory,
        curvetype::Symbol = :lossvsiteration;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        )
    if curvetype == :lossvsiteration
        xlabel = "Iteration"
        ylabel = "Loss"
        legendentry = "Loss function"
        xvalues, yvalues = ValueHistories.get(
            inputvaluehistories,
            :lossatiteration,
            )
    elseif curvetype == :lossvsepoch
        xlabel = "Epoch"
        ylabel = "Loss"
        legendentry = "Loss function"
        xvalues, yvalues = ValueHistories.get(
            inputvaluehistories,
            :lossatepoch,
            )
    else
        error("curvetype must be one of: :lossvsiteration, :lossvsepoch")
    end
    result = plotlearningcurve(
        xvalues,
        yvalues,
        xlabel,
        ylabel,
        legendentry;
        window = window,
        legendPos = legendPos,
        sampleevery = sampleevery,
        )
    return result
end

function plotlearningcurve(
        xvalues::StatsBase.RealVector,
        yvalues::StatsBase.RealVector,
        xlabel::AbstractString,
        ylabel::AbstractString,
        legendentry::AbstractString;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        )
    if sampleevery < 1
        error("sampleevery must be >=1")
    end
    if length(xvalues) !== length(yvalues)
        error("length(xvalues) !== length(yvalues)")
    end
    if length(xvalues) == 0
        error("length(xvalues) == 0")
    end
    xvalues = xvalues[1:sampleevery:end]
    yvalues = yvalues[1:sampleevery:end]
    allplotobjects = []
    linearplotobject_yraw = PGFPlots.Plots.Linear(
        xvalues,
        yvalues,
        legendentry = LaTeXStrings.LaTeXString(legendentry),
        mark = "none",
        )
    push!(allplotobjects, linearplotobject_yraw)
    if window > 0
        yvaluessmoothed = simplemovingaverage(
            yvalues,
            window,
            )
        legendentry_smoothed = string(legendentry, " (smoothed)")
        linearplotobject_ysmoothed = PGFPlots.Plots.Linear(
            xvalues,
            yvaluessmoothed,
            legendentry = LaTeXStrings.LaTeXString(legendentry_smoothed),
            mark = "none",
            )
        push!(allplotobjects, linearplotobject_ysmoothed)
    end
    axisobject = PGFPlots.Axis(
        [allplotobjects...],
        xlabel = LaTeXStrings.LaTeXString(xlabel),
        ylabel = LaTeXStrings.LaTeXString(ylabel),
        legendPos = legendPos,
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end

const plotlearningcurves = plotlearningcurve
