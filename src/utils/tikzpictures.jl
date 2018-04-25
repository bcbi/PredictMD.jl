import TikzPictures

function save(tp::TikzPictures.TikzPicture, filename::AbstractString)
    extension = lowercase(strip(splitext(filename)[2]))
    if extension == ".pdf"
        return save_pdf(tp, filename)
    elseif extension == ".tex"
        return save_tex(tp, filename)
    elseif extension == ".tikz"
        return save_tikz(tp, filename)
    elseif extension == ".svg"
        return save_svg(tp, filename)
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

function save_pdf(tp::TikzPictures.TikzPicture, filename::AbstractString)
    result = TikzPictures.save(TikzPictures.PDF(filename), tp)
    return result
end

function save_tex(tp::TikzPictures.TikzPicture, filename::AbstractString)
    result = TikzPictures.save(TikzPictures.TEX(filename), tp)
    return result
end

function save_tikz(tp::TikzPictures.TikzPicture, filename::AbstractString)
    result = TikzPictures.save(TikzPictures.TIKZ(filename), tp)
    return result
end

function save_svg(tp::TikzPictures.TikzPicture, filename::AbstractString)
    result = TikzPictures.save(TikzPictures.SVG(filename), tp)
    return result
end

function open(tp::TikzPictures.TikzPicture)
    tempsvgfilename = string(tempname(), ".svg")
    result = open(tp, tempsvgfilename)
    return result
end

function open(tp::TikzPictures.TikzPicture, filename::AbstractString)
    saveresult = save_svg(tp, filename)
    openresult = open(filename)
    return openresult
end
