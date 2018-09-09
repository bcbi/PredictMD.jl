##### Beginning of file

function is_force_test_plots(a::AbstractDict = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_TEST_PLOTS", ""))) == "true"
    return result
end

function handle_plotting_error(e::Exception, a::AbstractDict = ENV)::Nothing
    if is_force_test_plots(a)
        @warn(
            string(
                "PREDICTMD_TEST_PLOTS is true ,",
                "so rethrowing the error.",
                )
            )
        rethrow(e)
    else
        @warn(string("ignoring error:", e))
        return nothing
    end
end

##### End of file
