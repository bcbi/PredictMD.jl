# Based on https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl

function openbrowserwindow(filename::AbstractString)
    if haskey(ENV, "RUNNINGTESTS") && ENV["RUNNINGTESTS"] == "true"
        # If openbrowserwindow() is called during the test suite, it should do
        # nothing. Otherwise, if the tests are being run on Travis, xdg-open
        # will not work and the build will fail.
        # msg = string(
        #     "Will not open file because tests are being run. (filename: ",
        #     filename,
        #     ")",
        #     )
        # warn(msg)
        warn(
            string(
                "Skipping opening file because test suite is being run.\n",
                "filename: ",
                filename,
                )
            )
        return
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
