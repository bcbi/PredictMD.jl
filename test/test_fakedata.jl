srand(999)

using DataFrames

num_rows = 5_000_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefakedata(num_rows)
@test(typeof(dataframe) == DataFrame)
@test(size(dataframe,1) == num_rows)
@test(typeof(label_variables) == Vector{Symbol})
@test(length(label_variables) > 0)
@test(typeof(feature_variables) == Vector{Symbol})
@test(length(feature_variables) > 0)

tabular_dataset = AluthgeSinhaBase.TabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

@test(typeof(tabular_dataset) <: AluthgeSinhaBase.AbstractTabularDataset)
