import LaTeXStrings
import PGFPlots
import PGFPlotsX
import StatsBase
import ValueHistories

"""
"""
function plotlearningcurves(
        inputobject::Fittable,
        curvetype::Symbol = :loss_vs_iteration;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        startat::Union{Integer, Symbol} = :start,
        endat::Union{Integer, Symbol} = :end,
        include_validation::Bool = true,
        show_raw::Bool = true,
        show_smoothed::Bool = true,
        )
    history = get_history(inputobject)
    result = plotlearningcurve(
        history,
        curvetype;
        window = window,
        legendPos = legendPos,
        sampleevery = sampleevery,
        startat = startat,
        endat = endat,
        include_validation = include_validation,
        show_raw = show_raw,
        show_smoothed = show_smoothed,
        )
    return result
end

"""
"""
function plotlearningcurves(
        history::ValueHistories.MultivalueHistory,
        curvetype::Symbol = :loss_vs_iteration;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        startat::Union{Integer, Symbol} = :start,
        endat::Union{Integer, Symbol} = :end,
        include_validation::Bool = true,
        show_raw::Bool = true,
        show_smoothed::Bool = true,
        )
    if curvetype == :loss_vs_iteration
        has_validation = include_validation &&
                haskey(history, :validation_loss_at_iteration)
        xlabel = "Iteration"
        ylabel = "Loss"
        legendentry = "Loss function"
        training_xvalues, training_yvalues = ValueHistories.get(
            history,
            :training_loss_at_iteration,
            )
        if has_validation
            validation_xvalues, validation_yvalues = ValueHistories.get(
                history,
                :validation_loss_at_iteration,
                )
        end
    elseif curvetype == :loss_vs_epoch
        has_validation = include_validation &&
           haskey(history, :validation_loss_at_epoch)
        xlabel = "Epoch"
        ylabel = "Loss"
        legendentry = "Loss function"
        training_xvalues, training_yvalues = ValueHistories.get(
            history,
            :training_loss_at_epoch,
            )
        if has_validation
            validation_xvalues, validation_yvalues = ValueHistories.get(
                history,
                :validation_loss_at_epoch,
                )
        end
    else
        error("curvetype must be one of: :loss_vs_iteration, :loss_vs_epoch")
    end
    if length(training_xvalues) != length(training_yvalues)
        error("length(training_xvalues) != length(training_yvalues)")
    end
    if has_validation
        if length(training_xvalues) != length(validation_yvalues)
            error("length(training_xvalues) != length(validation_yvalues)")
        end
        if length(training_xvalues) != length(validation_xvalues)
            error("length(training_xvalues) != length(validation_xvalues)")
        end
        if !all(training_xvalues .== validation_xvalues)
            error("!all(training_xvalues .== validation_xvalues)")
        end
    end
    if startat == :start
        startat = 1
    elseif typeof(startat) <: Symbol
        error("$(startat) is not a valid value for startat")
    end
    if endat == :end
        endat = length(training_xvalues)
    elseif typeof(endat) <: Symbol
        error("$(endat) is not a valid value for endat")
    end
    if startat > endat
        error("startat > endat")
    end
    training_xvalues = training_xvalues[startat:endat]
    training_yvalues = training_yvalues[startat:endat]
    if has_validation
        validation_xvalues = validation_xvalues[startat:endat]
        validation_yvalues = validation_yvalues[startat:endat]
    end
    if length(training_xvalues) != length(training_yvalues)
        error("length(training_xvalues) != length(training_yvalues)")
    end
    if has_validation
        if length(validation_xvalues) != length(validation_yvalues)
            error("length(validation_xvalues) != length(validation_yvalues)")
        end
        if length(training_xvalues) != length(validation_xvalues)
            error("length(training_xvalues) != length(validation_xvalues)")
        end
        if !all(training_xvalues .== validation_xvalues)
            error("!all(training_xvalues .== validation_xvalues)")
        end
        result = plotlearningcurve(
            training_xvalues,
            training_yvalues,
            xlabel,
            ylabel,
            legendentry;
            window = window,
            legendPos = legendPos,
            sampleevery = sampleevery,
            validation_yvalues = validation_yvalues,
            show_raw = show_raw,
            show_smoothed = show_smoothed,
            )
    else
        Base.flush(Base.STDOUT)
        Base.flush(Base.STDOUT)
        result = plotlearningcurve(
            training_xvalues,
            training_yvalues,
            xlabel,
            ylabel,
            legendentry;
            window = window,
            legendPos = legendPos,
            sampleevery = sampleevery,
            show_raw = show_raw,
            show_smoothed = show_smoothed,
            )
    end
    return result
end

"""
"""
function plotlearningcurves(
        xvalues::AbstractVector{<:Real},
        training_yvalues::AbstractVector{<:Real},
        xlabel::AbstractString,
        ylabel::AbstractString,
        legendentry::AbstractString;
        window::Integer = 0,
        legendPos::AbstractString = "north east",
        sampleevery::Integer = 1,
        validation_yvalues::Union{Void, AbstractVector{<:Real}} = nothing,
        show_raw::Bool = true,
        show_smoothed::Bool = true,
        )
    if !show_raw && !show_smoothed
        error("At least one of show_raw, show_smoothed must be true.")
    end
    if is_nothing(validation_yvalues)
        has_validation = false
    else
        has_validation = true
    end
    if has_validation
        training_legendentry = string(strip(legendentry), ", training set")
        validation_legendentry = string(strip(legendentry), ", validation set")
    else
        training_legendentry = string(strip(legendentry), ", training set")
    end
    if sampleevery < 1
        error("sampleevery must be >=1")
    end
    if length(xvalues) != length(training_yvalues)
        error("length(xvalues) != length(training_yvalues)")
    end
    if length(xvalues) == 0
        error("length(xvalues) == 0")
    end
    xvalues = xvalues[1:sampleevery:end]
    training_yvalues = training_yvalues[1:sampleevery:end]
    if has_validation
        validation_yvalues = validation_yvalues[1:sampleevery:end]
    end
    allplotobjects = []
    if show_raw
        training_linearplotobject_yraw = PGFPlots.Plots.Linear(
            xvalues,
            training_yvalues,
            legendentry = LaTeXStrings.LaTeXString(training_legendentry),
            mark = "none",
            )
        push!(allplotobjects, training_linearplotobject_yraw)
        if has_validation
            validation_linearplotobject_yraw = PGFPlots.Plots.Linear(
                xvalues,
                validation_yvalues,
                legendentry = LaTeXStrings.LaTeXString(validation_legendentry),
                mark = "none",
                )
            push!(allplotobjects, validation_linearplotobject_yraw)
        end
        #

    end
    if show_smoothed && window > 0
        training_yvaluessmoothed = simple_moving_average(
            training_yvalues,
            window,
            )
        training_legendentry_smoothed = string(
                strip(training_legendentry),
                " (smoothed)",
                )
        training_linearplotobject_ysmoothed = PGFPlots.Plots.Linear(
            xvalues,
            training_yvaluessmoothed,
            legendentry = LaTeXStrings.LaTeXString(training_legendentry_smoothed),
            mark = "none",
            )
        push!(allplotobjects, training_linearplotobject_ysmoothed)
        #
        if has_validation
            validation_yvaluessmoothed = simple_moving_average(
                validation_yvalues,
                window,
                )
            validation_legendentry_smoothed = string(
                    strip(validation_legendentry),
                    " (smoothed)",
                    )
            validation_linearplotobject_ysmoothed = PGFPlots.Plots.Linear(
                xvalues,
                validation_yvaluessmoothed,
                legendentry = LaTeXStrings.LaTeXString(validation_legendentry_smoothed),
                mark = "none",
                )
            push!(allplotobjects, validation_linearplotobject_ysmoothed)
        end
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

const plotlearningcurve = plotlearningcurves
