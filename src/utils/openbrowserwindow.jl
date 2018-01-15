# Based on https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

function openbrowserwindow(filename::AbstractString)
    if istravisci(ENV)
        info(string("Skipping opening file during Travis build: ",filename,))
    else
        if is_apple()
            run(`open $(filename)`)
        elseif is_linux()
            run(`xdg-open $(filename)`)
        elseif is_bsd()
            run(`xdg-open $(filename)`)
        elseif is_windows()
            run(`$(ENV["COMSPEC"]) /c start "" "$(filename)"`)
        else
            error(
                string(
                    "unknown operating system; could not open file ",
                    filename,
                    )
                )
        end
        info(string("Opened file ",filename,))
    end
end
