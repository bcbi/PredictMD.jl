srand(999)

using DataFrames

num_rows = 5_000_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata(num_rows)
@test(typeof(dataframe) == DataFrame)
@test(size(dataframe,1) == num_rows)
@test(typeof(label_variables) == Vector{Symbol})
@test(length(label_variables) > 0)
@test(typeof(feature_variables) == Vector{Symbol})
@test(length(feature_variables) > 0)

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

@test(typeof(tabular_dataset) <: AbstractDataset)
@test(typeof(tabular_dataset) <: AbstractTabularDataset)
@test(typeof(tabular_dataset) <: AbstractHoldoutTabularDataset)
@test(typeof(tabular_dataset) <: HoldoutTabularDataset)

logistic_binary_classifier = SingleLabelBinaryLogisticClassifier(
    tabular_dataset,
    :mylabel1,
    )

@test(
    typeof(logistic_binary_classifier) <:
        AbstractSingleLabelBinaryClassifier
    )

modelperformance_logistic_binary_classifier = ModelPerformance(
    logistic_binary_classifier,
    )

@test(
    typeof(modelperformance_logistic_binary_classifier) <:
        AbstractModelPerformance
    )
