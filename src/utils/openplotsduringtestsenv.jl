"""
"""
function open_plots_during_tests(a::Associative)
    result =
        lowercase(get(a, "OPEN_PLOTS_DURING_TESTS", "")) == lowercase("true")
    return result
end
