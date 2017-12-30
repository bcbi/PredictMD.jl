# Based on https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

function openbrowserwindow(filename::AbstractString)
    if istravisci(ENV)
        # skip opening file during Travis builds
        warn(
            string(
                "Skipping opening file during Travis build. ",
                "filename: ",
                filename,
                )
            )
    else
        info(string("Attempting to open file: ", filename))
        if is_apple()
            result = run(`open $(filename)`)
            return result
        elseif is_linux()
            result = run(`xdg-open $(filename)`)
            return result
        elseif is_windows()
            result = run(`$(ENV["COMSPEC"]) /c start "" "$(filename)"`)
            return result
        elseif is_bsd()
            result = run(`xdg-open $(filename)`)
            return result
        else
            error("Unknown operating system; cannot open browser window.")
        end
    end
end
