import TikzPictures

function savesvg(tp::TikzPictures.TikzPicture, fn::AbstractString)
    result = TikzPictures.save(TikzPictures.SVG(fn), tp)
    return result
end

function open(tp::TikzPictures.TikzPicture)
    tempsvgfilename = string(tempname(), ".svg")
    result = open(tp, tempsvgfilename)
    return result
end

function open(tp::TikzPictures.TikzPicture, fn::AbstractString)
    saveresult = savesvg(tp, fn)
    openresult = open(fn)
    return openresult
end
