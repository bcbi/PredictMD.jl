##### Beginning of file

function is_force_test_plots(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_FORCE_TEST_PLOTS", ""))) ==
        "true"
    return result
end

function ignore_plotting_errors(
        a::Associative = ENV,
        )
    if is_travis_ci(a)
        return false
    elseif is_force_test_plots(a)
        return false
    else
        return true
    end
end

function handle_plotting_error(
        e::Exception,
        a::Associative = ENV,
        )
    if ignore_plotting_errors(a)
        warn(string("ignoring error: ", e))
        return nothing
    else
        rethrow(e)
    end
end

##### End of file
