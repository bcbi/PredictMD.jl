import DataFrames

function multilabelprobabilitiestopredictions(
        probabilitiesassoc::Associative,
        labelnames::SymbolVector;
        floattype::Type = Cfloat,
        )
    result = DataFrames.DataFrame()
    for j = 1:length(labelnames)
        result[labelnames[j]] = singlelabelprobabilitiestopredictions(
            probabilitiesassoc[labelnames[j]];
            floattype = floattype,
            )
    end
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
