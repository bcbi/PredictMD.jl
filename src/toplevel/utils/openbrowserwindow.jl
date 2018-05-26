# Parts of this file are based on:
# 1. https://github.com/JuliaPlots/Plots.jl/blob/master/src/backends/web.jl
# 2. https://github.com/JuliaGraphics/Luxor.jl/blob/master/src/Luxor.jl

import FileIO

"""
"""
function open_browser_window(
        filename::AbstractString,
        env_dict::Associative = ENV,
        )
    extension = filename_extension(filename)
    is_svg_file = extension == ".svg"
    is_png_file = extension == ".png"
    is_svg_or_png_file = is_svg_file || is_png_file
    is_ijulia = isdefined(Main, :IJulia) && Main.IJulia.inited
    if is_ijulia && is_svg_or_png_file
        Main.IJulia.clear_output(true)
        if is_svg_file
            open(filename) do f
                display(
                    "image/svg+xml",
                    readstring(f),
                    )
            end
        elseif is_png_file
            # We use Base.invokelatest to avoid world age errors
            Base.invokelatest(
                display,
                "image/png",
                FileIO.load(filename),
                )
        end
    elseif is_travis_ci(env_dict)
        info(string("DEBUG: Skipping opening file during Travis build: ",filename,))
        return nothing
    elseif is_runtests(env_dict) && !open_plots_during_tests(env_dict)
        info(string("DEBUG: Skipping opening file during package tests: ",filename,))
        return nothing
    elseif is_make_examples(env_dict)
        info(string("DEBUG: Skipping opening file during make_examples: ",filename,))
        return nothing
    elseif is_make_docs(env_dict)
        info(string("DEBUG: Skipping opening file during make_docs: ",filename,))
        return nothing
    elseif is_deploy_docs(env_dict)
        info(string("DEBUG: Skipping opening file during deploy_docs: ",filename,))
        return nothing
    else
        info(string("DEBUG: Opening file ",filename,))
        if is_apple()
            run_result = run(`open $(filename)`)
            return filename
        elseif is_linux()
            run_result = run(`xdg-open $(filename)`)
            return filename
        elseif is_bsd()
            run_result = run(`xdg-open $(filename)`)
            return filename
        elseif is_windows()
            run_result = run(`$(ENV["COMSPEC"]) /c start "" "$(filename)"`)
            return filename
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
