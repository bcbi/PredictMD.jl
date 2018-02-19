# Originally based on https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

function openbrowserwindow(filename::AbstractString)
    if istravisci(ENV)
        info(string("Skipping opening file during Travis build: ",filename,))
        return nothing
    elseif isruntests(ENV) && !openplotsduringtests(ENV)
        info(string("Skipping opening file during package tests: ",filename,))
        return nothing
    else
        info(string("Opening file ",filename,))
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

open(filename::AbstractString) = openbrowserwindow(filename)
