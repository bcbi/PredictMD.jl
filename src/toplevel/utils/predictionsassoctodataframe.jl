##### Beginning of file

import DataFrames

"""
"""
function predictionsassoctodataframe(
        probabilitiesassoc::AbstractDict,
        label_names::AbstractVector = [],
        )
    if length(label_names) == 0
        label_names = sort(unique(collect(keys(probabilitiesassoc))))
    end
    result = DataFrames.DataFrame()
    for j = 1:length(label_names)
        result[label_names[j]] = probabilitiesassoc[label_names[j]]
    end
    return result
end

##### End of file
