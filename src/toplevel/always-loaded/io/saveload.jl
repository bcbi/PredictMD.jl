import BSON
# import CSV
import CSVFiles
import DataFrames
import FileIO
import JLD2
import ProgressMeter

"""
"""
function save_model(
        filename::AbstractString,
        fittable_object_to_save::AbstractFittable,
        )
    if filename_extension(filename) == ".jld2"
        save_result = save_model_jld2(filename,fittable_object_to_save)
    elseif filename_extension(filename) == ".bson"
        save_result = save_model_bson(filename,fittable_object_to_save)
    else
        error("extension must be one of: .jld2, .bson")
    end
    return filename
end

function save_model_jld2(
        filename::AbstractString,
        fittable_object_to_save::AbstractFittable,
        )
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
    @debug("Attempting to save model...")
    # make sure the parent directory exists
    parent_directory = Base.Filesystem.dirname(filename)
    try
        Base.Filesystem.mkpath(parent_directory)
    catch
    end
    # save the .jld2 file
    FileIO.save(filename, dict_of_objects_to_save)
    @debug(string("Saved model to file \"", filename, "\""))
    return filename
end

function save_model_bson(
        filename::AbstractString,
        fittable_object_to_save::AbstractFittable,
        )
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
    @debug("Attempting to save model...")
    # make sure the parent directory exists
    parent_directory = Base.Filesystem.dirname(filename)
    try
        Base.Filesystem.mkpath(parent_directory)
    catch
    end
    # save the .bson file
    BSON.bson(filename, dict_of_objects_to_save)
    @debug(string("Saved model to file \"", filename, "\""))
    return filename
end

"""
"""
function load_model(filename::AbstractString)
    if filename_extension(filename) == ".jld2"
        load_result = load_model_jld2(filename)
        return load_result
    elseif filename_extension(filename) == ".bson"
        load_result = load_model_bson(filename)
        return load_result
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
    @debug("Attempting to load model...")
    dict_of_loaded_objects = FileIO.load(filename)
    loaded_fittable_object = dict_of_loaded_objects["jld2_saved_model"]
    @debug(string("Loaded model from file \"", filename, "\""))
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
    @debug("Attempting to load model...")
    dict_of_loaded_objects = BSON.load(filename)
    loaded_fittable_object = dict_of_loaded_objects[:bson_saved_model]
    @debug(string("Loaded model from file \"", filename, "\""))
    return loaded_fittable_object
end
