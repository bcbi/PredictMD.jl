"""
"""
function open_plots_during_tests(a::AbstractDict = ENV)
    result = lowercase(
        strip(
            get(a, "PREDICTMD_OPEN_PLOTS_DURING_TESTS", "")
            )
        ) == "true"
    return result
end

