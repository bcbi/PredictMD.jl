##### Beginning of file

import LaTeXStrings
import PGFPlotsX
import StatsBase
import ValueHistories

"""
"""
function plotlearningcurves(
        inputobject::Fittable,
        curvetype::Symbol = :loss_vs_iteration;
        kwargs...,
        )
    history::ValueHistories.MultivalueHistory = get_history(inputobject)
    result = plotlearningcurve(
        history,
        curvetype;
        kwargs...,
        )
    return result
end

"""
"""
function plotlearningcurves(
        history::ValueHistories.MultivalueHistory,
        curvetype::Symbol = :loss_vs_iteration;
        window::Integer = 0,
        legend_pos::AbstractString = "outer north east",
        sampleevery::Integer = 1,
        startat::Union{Integer, Symbol} = :start,
        endat::Union{Integer, Symbol} = :end,
        include_tuning::Bool = true,
        show_raw::Bool = true,
        show_smoothed::Bool = true,
        )
    legend_pos::String = convert(String, legend_pos)
    if curvetype==:loss_vs_iteration
        has_tuning = include_tuning &&
                haskey(history, :tuning_loss_at_iteration)
        xlabel = "Iteration"
        ylabel = "Loss"
        legendentry = "Loss function"
        training_xvalues, training_yvalues = ValueHistories.get(
            history,
            :training_loss_at_iteration,
            )
        if has_tuning
            tuning_xvalues, tuning_yvalues = ValueHistories.get(
                history,
                :tuning_loss_at_iteration,
                )
        end
    elseif curvetype==:loss_vs_epoch
        has_tuning = include_tuning &&
           haskey(history, :tuning_loss_at_epoch)
        xlabel = "Epoch"
        ylabel = "Loss"
        legendentry = "Loss function"
        training_xvalues, training_yvalues = ValueHistories.get(
            history,
            :training_loss_at_epoch,
            )
        if has_tuning
            tuning_xvalues, tuning_yvalues = ValueHistories.get(
                history,
                :tuning_loss_at_epoch,
                )
        end
    else
        error("\"curvetype\" must be one of: :loss_vs_iteration, :loss_vs_epoch")
    end
    if length(training_xvalues) != length(training_yvalues)
        error("length(training_xvalues) != length(training_yvalues)")
    end
    if has_tuning
        if length(training_xvalues) != length(tuning_yvalues)
            error("length(training_xvalues) != length(tuning_yvalues)")
        end
        if length(training_xvalues) != length(tuning_xvalues)
            error("length(training_xvalues) != length(tuning_xvalues)")
        end
        if !all(training_xvalues .== tuning_xvalues)
            error("!all(training_xvalues .== tuning_xvalues)")
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
    if has_tuning
        tuning_xvalues = tuning_xvalues[startat:endat]
        tuning_yvalues = tuning_yvalues[startat:endat]
    end
    if length(training_xvalues) != length(training_yvalues)
        error("length(training_xvalues) != length(training_yvalues)")
    end
    if has_tuning
        if length(tuning_xvalues) != length(tuning_yvalues)
            error("length(tuning_xvalues) != length(tuning_yvalues)")
        end
        if length(training_xvalues) != length(tuning_xvalues)
            error("length(training_xvalues) != length(tuning_xvalues)")
        end
        if !all(training_xvalues .== tuning_xvalues)
            error("!all(training_xvalues .== tuning_xvalues)")
        end
        result = plotlearningcurve(
            training_xvalues,
            training_yvalues,
            xlabel,
            ylabel,
            legendentry;
            window = window,
            legend_pos = legend_pos,
            sampleevery = sampleevery,
            tuning_yvalues = tuning_yvalues,
            show_raw = show_raw,
            show_smoothed = show_smoothed,
            )
    else
        result = plotlearningcurve(
            training_xvalues,
            training_yvalues,
            xlabel,
            ylabel,
            legendentry;
            window = window,
            legend_pos = legend_pos,
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
        legend_pos::AbstractString = "outer north east",
        sampleevery::Integer = 1,
        tuning_yvalues::Union{Nothing, AbstractVector{<:Real}} = nothing,
        show_raw::Bool = true,
        show_smoothed::Bool = true,
        )
    legend_pos::String = convert(String, legend_pos)
    if !show_raw && !show_smoothed
        error("At least one of show_raw, show_smoothed must be true.")
    end
    if is_nothing(tuning_yvalues)
        has_tuning = false
    else
        has_tuning = true
    end
    if has_tuning
        training_legendentry = string(strip(legendentry),
                ", training set")
        tuning_legendentry = string(strip(legendentry),
                ", tuning set")
    else
        training_legendentry = string(strip(legendentry),
                ", training set")
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
    if has_tuning
        tuning_yvalues = tuning_yvalues[1:sampleevery:end]
    end
    all_plots_and_legends = []
    if show_raw
        training_linearplotobject_yraw = PGFPlotsX.@pgf(
            PGFPlotsX.Plot(
                PGFPlotsX.Coordinates(
                    xvalues,
                    training_yvalues,
                    )
                )
           )
        training_legendentry_yraw = PGFPlotsX.@pgf(
            PGFPlotsX.LegendEntry(
                LaTeXStrings.LaTeXString(training_legendentry)
                )
            )
        push!(all_plots_and_legends, training_linearplotobject_yraw)
        push!(all_plots_and_legends, training_legendentry_yraw)
        if has_tuning
            tuning_linearplotobject_yraw = PGFPlotsX.@pgf(
                PGFPlotsX.Plot(
                    PGFPlotsX.Coordinates(
                        xvalues,
                        tuning_yvalues,
                        )
                    )
               )
            tuning_legendentry_yraw = PGFPlotsX.@pgf(
                PGFPlotsX.LegendEntry(
                    LaTeXStrings.LaTeXString(tuning_legendentry)
                    )
                )
            push!(all_plots_and_legends, tuning_linearplotobject_yraw)
            push!(all_plots_and_legends, tuning_legendentry_yraw)
        end
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
        training_linearplotobject_ysmoothed = PGFPlotsX.@pgf(
            PGFPlotsX.Plot(
                PGFPlotsX.Coordinates(
                    xvalues,
                    training_yvaluessmoothed,
                    )
                )
           )
        training_legendentry_ysmoothed = PGFPlotsX.@pgf(
            PGFPlotsX.LegendEntry(
                LaTeXStrings.LaTeXString(training_legendentry_smoothed)
                )
            )
        push!(all_plots_and_legends, training_linearplotobject_ysmoothed)
        push!(all_plots_and_legends, training_legendentry_ysmoothed)
        if has_tuning
            tuning_yvaluessmoothed = simple_moving_average(
                tuning_yvalues,
                window,
                )
            tuning_legendentry_smoothed = string(
                    strip(tuning_legendentry),
                    " (smoothed)",
                    )
            tuning_linearplotobject_ysmoothed = PGFPlotsX.@pgf(
                PGFPlotsX.Plot(
                    PGFPlotsX.Coordinates(
                        xvalues,
                        tuning_yvaluessmoothed,
                        )
                    )
               )
            tuning_legendentry_ysmoothed = PGFPlotsX.@pgf(
                PGFPlotsX.LegendEntry(
                    LaTeXStrings.LaTeXString(tuning_legendentry_smoothed)
                    )
                )
            push!(all_plots_and_legends, tuning_linearplotobject_ysmoothed)
            push!(all_plots_and_legends, tuning_legendentry_ysmoothed)
        end
    end
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                xlabel = LaTeXStrings.LaTeXString(xlabel),
                ylabel = LaTeXStrings.LaTeXString(ylabel),
                no_markers,
                legend_pos = legend_pos,
                },
            all_plots_and_legends...,
            ),
        )
    wrapper = PGFPlotsXPlot(p)
    return wrapper
end

const plotlearningcurve = plotlearningcurves

##### End of file
