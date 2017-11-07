srand(999)

using StatsBase

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata(num_rows)

countmap(dataframe[:mylabel1])

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

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
