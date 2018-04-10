import FileIO
import JLD2
import ProgressMeter

function save(filename::AbstractString, x::AbstractObject)
    # make sure that the filename ends in ".jld2"
    if !endswith(filename, ".jld2")
        error("filename must end in \".jld2\"")
    end

    # get all underlying objects
    allunderlying = getunderlying(x;saving=true,)

    # get all value history objects
    allhistory = gethistory(x;saving=true,)

    # make sure the parent directory exists
    parentdirectory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parentdirectory)

    # save the JLD2 file
    FileIO.save(
        filename,
        Dict(
            "allunderlying" => allunderlying,
            "allhistory" => allhistory,
            ),
        )

    # print info message
    info(string("Saved model to file ", filename))

    # return
    return nothing
end

function load!(filename::AbstractString, x::AbstractObject)
    # make sure that the filename ends in ".jld2"
    if !endswith(filename, ".jld2")
        error("filename must end in \".jld2\"")
    end
    
    # load the JLD2 file
    alldatasets = FileIO.load(filename)

    # get the underlying objects
    allunderlying = alldatasets["allunderlying"]

    # get the value history objects
    allhistory = alldatasets["allhistory"]

    # go through the AbstractObject and set all underlying objects
    setunderlying!(x,allunderlying;loading=true,)

    # go through the AbstractObject and set all value history objects
    sethistory!(x,allhistory;loading=true,)

    # print info message
    info(string("Loaded model from file ", filename))

    # return
    return nothing
end
