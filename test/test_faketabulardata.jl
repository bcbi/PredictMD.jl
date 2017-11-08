srand(999)

using DataFrames

num_rows = 5_000_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata1(num_rows)

@test(typeof(dataframe) == DataFrame)
@test(size(dataframe,1) == num_rows)
@test(typeof(label_variables) == Vector{Symbol})
@test(length(label_variables) > 0)
@test(typeof(feature_variables) == Vector{Symbol})
@test(length(feature_variables) > 0)
