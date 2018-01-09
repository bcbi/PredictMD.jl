import JLD2

function save(filename::AbstractString, x::AbstractObject)
    allunderlyingobjects_tosave = getunderlying(x)
    if allunderlyingobjects_tosave == nothing
        error("No objects to save.")
    else
        JLD2.save(
            filename,
            Dict(:allunderlyingobjects => allunderlyingobjects_tosave),
            )
    end
end

function load!(filename::AbstractString, x::AbstractObject)
    alldatasets = JLD2.load(
        filename,
        )
    allunderlyingobjects_fromfile = alldatasets[:allunderlyingobjects]
    if allunderlyingobjects_fromfile == nothing
        error("No objects to load.")
    else
        setunderlying!(x, allunderlyingobjects_fromfile)
    end
end
