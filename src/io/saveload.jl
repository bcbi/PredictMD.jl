import FileIO
import JLD2
import ProgressMeter

function save(filename::AbstractString, x::Fittable)
    # make sure that the filename ends in ".jld2"
    if splitext(filename)[2] !== ".jld2"
        error("filename must end in \".jld2\"")
    end

    # get all underlying objects
    allunderlying = get_underlying(x;saving=true,)

    # get all value history objects
    allhistory = get_history(x;saving=true,)

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

function load!(filename::AbstractString, x::Fittable)
    # make sure that the filename ends in ".jld2"
    if splitext(filename)[2] !== ".jld2"
        error("filename must end in \".jld2\"")
    end

    # load the JLD2 file
    alldatasets = FileIO.load(filename)

    # get the underlying objects
    allunderlying = alldatasets["allunderlying"]

    # get the value history objects
    allhistory = alldatasets["allhistory"]

    # go through the Fittable and set all underlying objects
    set_underlying!(x,allunderlying;loading=true,)

    # go through the Fittable and set all value history objects
    set_history!(x,allhistory;loading=true,)

    # print info message
    info(string("Loaded model from file ", filename))

    # return
    return nothing
end
