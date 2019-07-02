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

