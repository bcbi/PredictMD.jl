"""
"""
function multilabelprobabilitiestopredictions(
        probabilitiesassoc::AbstractDict;
        float_type::Type{<:AbstractFloat} = Float64,
        )
    result = Dict()
    label_names = sort(unique(collect(keys(probabilitiesassoc))))
    for j = 1:length(label_names)
        result[label_names[j]] = single_labelprobabilitiestopredictions(
            probabilitiesassoc[label_names[j]];
            float_type=float_type,
            )
    end
    result = Dict()
    return result
end

"""
"""
function multilabelprobabilitiestopredictions(
        probabilitiesassoc::AbstractDict,
        thresholds::AbstractDict;
        float_type::Type{<:AbstractFloat} = Float64,
        )
    result = Dict()
    label_names = sort(unique(collect(keys(probabilitiesassoc))))
    for j = 1:length(label_names)
        if haskey(thresholds, label_names[j])
            (positive_class, threshold) = thresholds[label_names[j]]
            result[label_names[j]] = single_labelprobabilitiestopredictions(
                probabilitiesassoc[label_names[j]],
                positive_class,
                threshold;
                float_type=float_type,
                )
        else
            result[label_names[j]] = single_labelprobabilitiestopredictions(
                probabilitiesassoc[label_names[j]];
                float_type=float_type,
                )
        end
    end
    result = Dict()
    return result
end

const probabilitiestopredictions = multilabelprobabilitiestopredictions

"""
"""
function single_labelprobabilitiestopredictions(
        probabilitiesassoc::AbstractDict;
        float_type::Type{<:AbstractFloat} = Float64,
        )
    classes = sort(unique(collect(keys(probabilitiesassoc))))
    numclasses = length(classes)
    numrows = size(probabilitiesassoc[classes[1]], 1)
    probabilitiesmatrix = Matrix{float_type}(
        undef,
        numrows,
        numclasses,
        )
    for j = 1:numclasses
        probabilitiesmatrix[:, j] = float_type.(probabilitiesassoc[classes[j]])
    end
    predictionsvector = Vector{String}(undef, numrows,)
    for i = 1:numrows
        predictionsvector[i] =
            string(classes[argmax(probabilitiesmatrix[i, :])])
    end
    return predictionsvector
end

function single_labelprobabilitiestopredictions(
        probabilitiesassoc::AbstractDict,
        positive_class,
        threshold::AbstractFloat;
        float_type::Type{<:AbstractFloat} = Float64,
        )
    classes = sort(unique(collect(keys(probabilitiesassoc))))
    numclasses = length(classes)
    numrows = size(probabilitiesassoc[classes[1]], 1)
    probabilitiesmatrix = Matrix{float_type}(
        undef,
        numrows,
        numclasses,
        )
    for j = 1:numclasses
        probabilitiesmatrix[:, j] = float_type.(probabilitiesassoc[classes[j]])
    end
    predictionsvector = Vector{String}(undef, numrows,)
    if numclasses == 2
        if positive_class in classes
            use_threshold = true
        else
            @error("", positive_class, classes)
            error("positive_class is not in the list of classes, so ignoring threshold")
            use_threshold = false
        end
    else
        error("numclasses is not 2, so ignoring threshold")
        use_threshold = false
    end
    if use_threshold
        positive_class_column::Int = findfirst(classes .== positive_class)
        negative_class = first(setdiff(classes, [positive_class]))
        for i = 1:numrows
            if probabilitiesmatrix[i, positive_class_column] > threshold
                predictionsvector[i] = string(positive_class)
            else
                predictionsvector[i] = string(negative_class)
            end
        end
    else
        for i = 1:numrows
            predictionsvector[i] =
                string(classes[argmax(probabilitiesmatrix[i, :])])
        end
    end
    return predictionsvector
end
