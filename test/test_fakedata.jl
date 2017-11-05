srand(999)

using DataFrames

num_rows = 5_000_000
dataframe, original_label_variables, feature_variables =
    AluthgeSinhaBase.generatefakedata(num_rows)
@test(typeof(dataframe) == DataFrame)
@test(size(dataframe,1) == num_rows)
@test(typeof(original_label_variables) == Vector{Symbol})
@test(length(original_label_variables) == 1)
@test(typeof(feature_variables) == Vector{Symbol})
@test(length(feature_variables) > 0)
label_coding_map = Dict("classzero" => 0, "classone" => 1)

tabular_dataset = AluthgeSinhaBase.TabularDataset(
    dataframe,
    original_label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )
