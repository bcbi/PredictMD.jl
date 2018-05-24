import BSON
import FileIO
import JLD2
import ProgressMeter

"""
"""
function save_model(filename::AbstractString,fittable_object_to_save::Fittable)
    if filename_extension(filename) == ".jld2"
        result = save_model_jld2(filename,fittable_object_to_save)
    elseif filename_extension(filename) == ".bson"
        result = save_model_bson(filename,fittable_object_to_save)
    else
        error("extension must be one of: .jld2, .bson")
    end
end

function save_model_jld2(filename::AbstractString,fittable_object_to_save::Fittable)
    if filename_extension(filename) != ".jld2"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".jld2\"")
            )
    end
    dict_of_objects_to_save = Dict(
        "jld2_saved_model" => fittable_object_to_save,
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

function save_model_bson(filename::AbstractString,fittable_object_to_save::Fittable)
    if filename_extension(filename) != ".bson"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".bson\"")
            )
    end
    dict_of_objects_to_save = Dict(
        :bson_saved_model => fittable_object_to_save,
        )
    info("INFO Attempting to save model...")
    # make sure the parent directory exists
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    # save the .bson file
    BSON.bson(filename, dict_of_objects_to_save)
    info(string("INFO Saved model to file \"", filename, "\""))
end

"""
"""
function load_model(filename::AbstractString)
    if filename_extension(filename) == ".jld2"
        result = load_model_jld2(filename)
        return result
    elseif filename_extension(filename) == ".bson"
        result = load_model_bson(filename)
        return result
    else
        error("extension must be one of: .jld2, .bson")
    end
end

function load_model_jld2(filename::AbstractString)
    if filename_extension(filename) != ".jld2"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".jld2\"")
            )
    end
    info("INFO Attempting to load model...")
    dict_of_loaded_objects = FileIO.load(filename)
    loaded_fittable_object = dict_of_loaded_objects["jld2_saved_model"]
    info(string("INFO Loaded model from file \"", filename, "\""))
    return loaded_fittable_object
end

function load_model_bson(filename::AbstractString)
    if filename_extension(filename) != ".bson"
        error(
            string(
                "Filename \"",
                filename,
                "\" does not end in \".bson\"")
            )
    end
    info("INFO Attempting to load model...")
    dict_of_loaded_objects = BSON.load(filename)
    loaded_fittable_object = dict_of_loaded_objects[:bson_saved_model]
    info(string("INFO Loaded model from file \"", filename, "\""))
end
