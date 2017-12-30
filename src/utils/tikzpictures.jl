import TikzPictures

function savesvg(tp::TikzPictures.TikzPicture, fn::AbstractString)
    result = TikzPictures.save(TikzPictures.SVG(fn), tp)
    return result
end

function open(tp::TikzPictures.TikzPicture)
    tempsvgfilename = string(tempname(), ".svg")
    saveresult = savesvg(tp, tempsvgfilename)
    openresult = openbrowserwindow(tempsvgfilename)
    return openresult
end
