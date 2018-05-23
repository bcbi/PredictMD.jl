import DataFrames

"""
"""
function predictionsassoctodataframe(
        probabilitiesassoc::Associative,
        labelnames::AbstractVector = [],
        )
    if length(labelnames) == 0
        labelnames = sort(unique(collect(keys(probabilitiesassoc))))
    end
    result = DataFrames.DataFrame()
    for j = 1:length(labelnames)
        result[labelnames[j]] = probabilitiesassoc[labelnames[j]]
    end
    return result
end
