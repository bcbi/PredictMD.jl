##### Beginning of file

import PGFPlotsX

function get_underlying(p::PGFPlotsXPlot{T})::T where T
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
        @info(string("Attempting to display plot..."))
        try
            Base.display(get_underlying(p))
            @info(string("Displayed plot."))
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
        @info(string("Attempting to save plot..."))
        PGFPlotsX.save(filename,underlying_object;kwargs...)
        @info(string("Saved plot to file: \"", filename, "\"",))
    catch e
        handle_plotting_error(e)
    end
    return nothing
end

##### End of file
