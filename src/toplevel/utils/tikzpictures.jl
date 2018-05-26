import TikzPictures

"""
"""
function save_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
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
function save_plot_pdf(filename::AbstractString, tp::TikzPictures.TikzPicture)
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = TikzPictures.save(TikzPictures.PDF(filename), tp)
    return filename
end

"""
"""
function save_plot_tex(filename::AbstractString, tp::TikzPictures.TikzPicture)
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = TikzPictures.save(TikzPictures.TEX(filename), tp)
    return filename
end

"""
"""
function save_plot_tikz(filename::AbstractString, tp::TikzPictures.TikzPicture)
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = TikzPictures.save(TikzPictures.TIKZ(filename), tp)
    return filename
end

"""
"""
function save_plot_svg(filename::AbstractString, tp::TikzPictures.TikzPicture)
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    save_result = TikzPictures.save(TikzPictures.SVG(filename), tp)
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
function open_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
    saveresult = save_plot(filename, tp)
    open_result = open_browser_window(filename)
    return filename
end
