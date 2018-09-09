##### Beginning of file

import PGFPlotsX

struct PGFPlotsXPlot{T} <: AbstractPlot{T}
    plot::T
end

function Base.display(p::PGFPlotsXPlot)::Nothing
    if is_runtests() && !open_plots_during_tests()
        @info(
            string(
                "PREDICTMD_OPEN_PLOTS_DURING_TESTS is false, therefore ",
                "the plot will not be opened.",
                )
            )
    else
        @info(string("Attempting to display plot..."))
        try
            Base.display(p.plot)
            @info(string("Displayed plot."))
        catch e
            handle_plotting_error(e)
        end
    end
    return nothing
end

##### End of file
