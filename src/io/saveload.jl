import BSON
import FileIO
import JLD2
import ProgressMeter

"""
"""
function save_model(filename::AbstractString,fittable_object_to_save::Fittable)
    # make sure that the filename ends in ".jld2"
    if lowercase(strip(splitext(filename)[2])) != ".jld2"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".jld2\"")
            )
    end
    dict_of_objects_to_save = Dict(
        "saved_model" => fittable_object_to_save,
        )
    info("INFO Attempting to save model...")
    # make sure the parent directory exists
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    # save the .jld2 file
    FileIO.save(filename, dict_of_objects_to_save)
    info(string("INFO Saved model to file \"", filename, "\""))
    return nothing
end

"""
"""
function load_model(filename::AbstractString)
    # make sure that the filename ends in ".jld2"
    if lowercase(strip(splitext(filename)[2])) != ".jld2"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".jld2\"")
            )
    end
    info("INFO Attempting to load model...")
    dict_of_loaded_objects = FileIO.load(filename)
    loaded_fittable_object = dict_of_loaded_objects["saved_model"]
    info(string("INFO Loaded model from file \"", filename, "\""))
    return loaded_fittable_object
end
