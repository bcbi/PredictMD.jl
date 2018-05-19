function multilabelprobabilitiestopredictions(
        probabilitiesassoc::Associative;
        floattype::Type = Cfloat,
        )
    result = Dict()
    labelnames = sort(unique(collect(keys(probabilitiesassoc))))
    for j = 1:length(labelnames)
        result[labelnames[j]] = singlelabelprobabilitiestopredictions(
            probabilitiesassoc[labelnames[j]];
            floattype = floattype,
            )
    end
    result = Dict()
    return result
end

const probabilitiestopredictions = multilabelprobabilitiestopredictions

function singlelabelprobabilitiestopredictions(
        probabilitiesassoc::Associative;
        floattype::Type = Cfloat,
        )
    classes = sort(unique(collect(keys(probabilitiesassoc))))
    numclasses = length(classes)
    @assert(typeof(probabilitiesassoc[classes[1]]) <: AbstractVector)
    numrows = size(probabilitiesassoc[classes[1]], 1)
    probabilitiesmatrix = Matrix{floattype}(numrows, numclasses)
    for j = 1:numclasses
        probabilitiesmatrix[:, j] = floattype.(probabilitiesassoc[classes[j]])
    end
    @assert( all( isapprox.( sum(probabilitiesmatrix, 2) , 1.0 ) ) )
    predictionsvector = Vector{String}(numrows)
    for i = 1:numrows
        predictionsvector[i] =
            string(classes[indmax(probabilitiesmatrix[i, :])])
    end
    return predictionsvector
end
