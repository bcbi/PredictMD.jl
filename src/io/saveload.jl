import FileIO
import JLD2

function save(filename::AbstractString, x::AbstractObject)
    if !endswith(filename, ".jld2")
        error("filename must end in \".jld2\"")
    end
    allunderlying = getunderlying(x;saving=true,)
    allhistory = gethistory(x;saving=true,)
    FileIO.save(
        filename,
        Dict(
            "allunderlying" => allunderlying,
            "allhistory" => allhistory,
            ),
        )
    info(string("Saved model to file ", filename))
    return nothing
end

function load!(filename::AbstractString, x::AbstractObject)
    alldatasets = FileIO.load(filename)
    allunderlying = alldatasets["allunderlying"]
    allhistory = alldatasets["allhistory"]
    setunderlying!(x,allunderlying;loading=true,)
    sethistory!(x,allhistory;loading=true,)
    info(string("Loaded model from file ", filename))
    return nothing
end
