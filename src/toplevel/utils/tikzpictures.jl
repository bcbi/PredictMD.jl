import TikzPictures

"""
"""
function is_force_test_plots(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_FORCE_TEST_PLOTS", ""))) ==
        "true"
    return result
end

"""
"""
function warn_on_tikzpictures_save_error(
        e::Exception,
        a::Associative = ENV,
        )
    if is_travis_ci(a)
        warn(
            string(
                "this is a travis build, so rethrowing the exception",
                )
            )
        rethrow(e)
    elseif is_force_test_plots(a)
        warn(
            string(
                "PREDICTMD_IS_FORCE_TEST_PLOTS is true, ",
                "so rethrowing the exception",
                )
            )
        rethrow(e)
    else
        warn(
            string(
                "Ignoring error: ",
                e,
                )
            )
        return nothing
    end
end

"""
"""
function save_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    extension = filename_extension(filename)
    if extension == ".pdf"
        save_result = save_plot_pdf(filename, tp)
    elseif extension == ".tex"
        save_result = save_plot_tex(filename, tp)
    elseif extension == ".tikz"
        save_result = save_plot_tikz(filename, tp)
    elseif extension == ".svg"
        save_result = save_plot_svg(filename, tp)
    else
        error("File extension must be one of: .pdf, .tex, .tikz, .svg")
    end
    return filename
end

"""
"""
function save_plot_pdf(
        filename::AbstractString,
        tp::TikzPictures.TikzPicture,
        )
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    extension = filename_extension(filename)
    if extension != ".pdf"
        error("filename must end in .pdf")
    end
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = try
        TikzPictures.save(TikzPictures.PDF(filename), tp)
    catch e
        warn_on_tikzpictures_save_error(e)
    end
    return filename
end

"""
"""
function save_plot_tex(
        filename::AbstractString,
        tp::TikzPictures.TikzPicture,
        )
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    extension = filename_extension(filename)
    if extension != ".tex"
        error("filename must end in .tex")
    end
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = try
        TikzPictures.save(TikzPictures.TEX(filename), tp)
    catch e
        warn_on_tikzpictures_save_error(e)
    end
    return filename
end

"""
"""
function save_plot_tikz(
        filename::AbstractString,
        tp::TikzPictures.TikzPicture,
        )
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    if extension != ".tikz"
        error("filename must end in .tikz")
    end
    extension = filename_extension(filename)
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = try
        TikzPictures.save(TikzPictures.TIKZ(filename), tp)
    catch e
        warn_on_tikzpictures_save_error(e)
    end
    return filename
end

"""
"""
function save_plot_svg(
        filename::AbstractString,
        tp::TikzPictures.TikzPicture,
        )
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    extension = filename_extension(filename)
    if extension != ".svg"
        error("filename must end in .svg")
    end
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = try
        TikzPictures.save(TikzPictures.SVG(filename), tp)
    catch e
        warn_on_tikzpictures_save_error(e)
    end
    return filename
end

"""
"""
function open_plot(tp::TikzPictures.TikzPicture)
    temp_svg_filename = string(tempname(), ".svg")
    save_result = open_plot(temp_svg_filename, tp)
    return temp_svg_filename
end

"""
"""
function open_plot(
        filename::AbstractString,
        tp::TikzPictures.TikzPicture,
        )
    filename = strip(filename)
    if length(filename) == 0
        error("filename is an empty string")
    end
    saveresult = save_plot(filename, tp)
    open_result = open_browser_window(filename)
    return filename
end
