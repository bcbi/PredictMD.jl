import TikzPictures

function save_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
    extension = lowercase(strip(splitext(filename)[2]))
    if extension == ".pdf"
        return save_plot_pdf(filename, tp)
    elseif extension == ".tex"
        return save_plot_tex(filename, tp)
    elseif extension == ".tikz"
        return save_plot_tikz(filename, tp)
    elseif extension == ".svg"
        return save_plot_svg(filename, tp)
    else
        error(
            string(
                "I don't know how to save a picture in file format \"",
                extension,
                "\".",
                )
            )
    end
end

function save_plot_pdf(filename::AbstractString, tp::TikzPictures.TikzPicture)
    result = TikzPictures.save(TikzPictures.PDF(filename), tp)
    return result
end

function save_plot_tex(filename::AbstractString, tp::TikzPictures.TikzPicture)
    result = TikzPictures.save(TikzPictures.TEX(filename), tp)
    return result
end

function save_plot_tikz(filename::AbstractString, tp::TikzPictures.TikzPicture)
    result = TikzPictures.save(TikzPictures.TIKZ(filename), tp)
    return result
end

function save_plot_svg(filename::AbstractString, tp::TikzPictures.TikzPicture)
    result = TikzPictures.save(TikzPictures.SVG(filename), tp)
    return result
end

function open_plot(tp::TikzPictures.TikzPicture)
    tempsvgfilename = string(tempname(), ".svg")
    result = open_plot(tempsvgfilename, tp)
    return result
end

function open_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
    saveresult = save_plot_svg(filename, tp)
    openresult = open_browser_window(filename)
    return openresult
end
