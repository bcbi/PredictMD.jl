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
        startat::Union{Integer, Symbol} = :start,
        endat::Union{Integer, Symbol} = :end,
        )
    history = gethistory(inputobject)
    result = plotlearningcurve(
        history,
        curvetype,
        window = window,
        legendPos = legendPos,
        sampleevery = sampleevery,
        startat = startat,
        endat = endat,
        )
    return result
end

function plotlearningcurve(
        history::ValueHistories.MultivalueHistory,
        curvetype::Symbol = :lossvsiteration;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        startat::Union{Integer, Symbol} = :start,
        endat::Union{Integer, Symbol} = :end,
        )
    if curvetype == :lossvsiteration
        xlabel = "Iteration"
        ylabel = "Loss"
        legendentry = "Loss function"
        xvalues, yvalues = ValueHistories.get(
            history,
            :lossatiteration,
            )
    elseif curvetype == :lossvsepoch
        xlabel = "Epoch"
        ylabel = "Loss"
        legendentry = "Loss function"
        xvalues, yvalues = ValueHistories.get(
            history,
            :lossatepoch,
            )
    else
        error("curvetype must be one of: :lossvsiteration, :lossvsepoch")
    end
    if length(xvalues) != length(yvalues)
        error("length(xvalues) != length(yvalues)")
    end
    if startat == :start
        startat = 1
    elseif typeof(startat) <: Symbol
        error("$(startat) is not a valid value for startat")
    end
    if endat == :end
        endat = length(xvalues)
    elseif typeof(endat) <: Symbol
        error("$(endat) is not a valid value for endat")
    end
    if startat > endat
        error("startat > endat")
    end
    xvalues = xvalues[startat:endat]
    yvalues = yvalues[startat:endat]
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
    if length(xvalues) != length(yvalues)
        error("length(xvalues) != length(yvalues)")
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
