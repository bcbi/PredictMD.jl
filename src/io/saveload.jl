import BSON
import ProgressMeter

function save(filename::AbstractString, fittable_object_to_save::Fittable)
    # make sure that the filename ends in ".bson"
    if lowercase(strip(splitext(filename)[2])) != ".bson"
        error(
            string(
                "Filename \"",
                filename,
                "",
                "\" does not end in \".bson\"")
            )
    end
    dict_of_objects_to_save = Dict()
    dict_of_objects_to_save[:saved_fittable_object] = fittable_object_to_save
    info("Attempting to save model...")
    # make sure the parent directory exists
    parent_directory = Base.Filesystem.dirname(filename)
    Base.Filesystem.mkpath(parent_directory)
    # save the .bson file
    BSON.bson(filename, dict_of_objects_to_save)
    info(string("Saved model to file \"", filename, "\""))
    return nothing
end

function load(filename::AbstractString)
    # make sure that the filename ends in ".bson"
    if lowercase(strip(splitext(filename)[2])) != ".bson"
        error(
            string(
                "Filename \"",
                filename,
                "",
                "\" does not end in \".bson\"")
            )
    end
    info("Attempting to load model...")
    dict_of_loaded_objects = BSON.load(filename)
    loaded_fittable_object = dict_of_loaded_objects[:saved_fittable_object]
    info(string("Loaded model from file \"", filename, "\""))
    return loaded_fittable_object
end
