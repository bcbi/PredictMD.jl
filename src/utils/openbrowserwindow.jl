# Source: https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

function openbrowserwindow(filename::AbstractString)
    if is_apple()
        result = run(`open $(filename)`)
        return result
    elseif is_linux() || is_bsd()
        result = run(`xdg-open $(filename)`)
        return result
    elseif is_windows()
        result = run(`$(ENV["COMSPEC"]) /c start "" "$(filename)"`)
        return result
    else
        error("Unknown operating system; cannot open browser window.")
    end
end
