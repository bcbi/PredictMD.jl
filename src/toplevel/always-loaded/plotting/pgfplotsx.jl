import PGFPlotsX

function get_underlying(p::PGFPlotsXPlot)
    result = p.underlying_object
    return result
end

function Base.display(p::PGFPlotsXPlot)::Nothing
    if is_runtests() && !open_plots_during_tests()
        @debug(
            string(
                "PREDICTMD_OPEN_PLOTS_DURING_TESTS is false, therefore ",
                "the plot will not be opened.",
                )
            )
    else
        @debug(string("Attempting to display plot..."))
        try
            Base.display(get_underlying(p))
            @debug(string("Displayed plot."))
        catch e
            handle_plotting_error(e)
        end
    end
    return nothing
end

function PGFPlotsX.save(
        filename::String,
        p::PGFPlotsXPlot;
        kwargs...,
        )::Nothing
    underlying_object = get_underlying(p)
    try
        @debug(string("Attempting to save plot..."))
        mkpath(dirname(filename))
        PGFPlotsX.save(
            filename,
            underlying_object;
            kwargs...,
            )
        @debug(string("Saved plot to file: \"", filename, "\"",))
    catch e
        handle_plotting_error(e)
    end
    return nothing
end

function save_plot(
        filename::String,
        p::PGFPlotsXPlot;
        kwargs...,
        )::Nothing
    PGFPlotsX.save(
        filename,
        p;
        kwargs...,
        )
    return nothing
end

