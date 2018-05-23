# Originally based on https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

"""
"""
function open_browser_window(
        filename::AbstractString,
        env_dict::Associative = ENV,
        )
    if is_travis_ci(env_dict)
        info(string("DEBUG Skipping opening file during Travis build: ",filename,))
        return nothing
    elseif is_runtests(env_dict) && !open_plots_during_tests(env_dict)
        info(string("DEBUG Skipping opening file during package tests: ",filename,))
        return nothing
    elseif is_make_docs(env_dict)
        info(string("DEBUG Skipping opening file during make_docs: ",filename,))
        return nothing
    elseif is_deploy_docs(env_dict)
        info(string("DEBUG Skipping opening file during deploy_docs: ",filename,))
        return nothing
    else
        info(string("DEBUG Opening file ",filename,))
        if is_apple()
            result = run(`open $(filename)`)
            return result
        elseif is_linux()
            result = run(`xdg-open $(filename)`)
            return result
        elseif is_bsd()
            result = run(`xdg-open $(filename)`)
            return result
        elseif is_windows()
            result = run(`$(ENV["COMSPEC"]) /c start "" "$(filename)"`)
            return result
        else
            error(
                string(
                    "unknown operating system; could not open file ",
                    filename,
                    )
                )
        end
    end
end
