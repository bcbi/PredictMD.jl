"""
"""
function open_plots_during_tests(a::Associative = ENV)
    result = lowercase(strip(get(a, "OPEN_PLOTS_DURING_TESTS", ""))) == "true"
    return result
end
