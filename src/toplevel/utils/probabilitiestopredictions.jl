##### Beginning of file

"""
"""
function multilabelprobabilitiestopredictions(
        probabilitiesassoc::Associative;
        floattype::Type = Cfloat,
        )
    result = Dict()
    label_names = sort(unique(collect(keys(probabilitiesassoc))))
    for j = 1:length(label_names)
        result[label_names[j]] = single_labelprobabilitiestopredictions(
            probabilitiesassoc[label_names[j]];
            floattype = floattype,
            )
    end
    result = Dict()
    return result
end

const probabilitiestopredictions = multilabelprobabilitiestopredictions

"""
"""
function single_labelprobabilitiestopredictions(
        probabilitiesassoc::Associative;
        floattype::Type = Cfloat,
        )
    classes = sort(unique(collect(keys(probabilitiesassoc))))
    numclasses = length(classes)
    numrows = size(probabilitiesassoc[classes[1]], 1)
    probabilitiesmatrix = Matrix{floattype}(numrows, numclasses)
    for j = 1:numclasses
        probabilitiesmatrix[:, j] = floattype.(probabilitiesassoc[classes[j]])
    end
    predictionsvector = Vector{String}(numrows)
    for i = 1:numrows
        predictionsvector[i] =
            string(classes[indmax(probabilitiesmatrix[i, :])])
    end
    return predictionsvector
end

##### End of file
