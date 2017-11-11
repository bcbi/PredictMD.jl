srand(999)

using DataFrames
using StatsBase

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata1(num_rows)

StatsBase.countmap(dataframe[:mylabel1])

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

randomforest_binary_classifier = BinaryRandomForest(
    tabular_dataset,
    :mylabel1,
    )

@test(
    typeof(randomforest_binary_classifier) <:
        AbstractSingleLabelBinaryClassifier
    )

performance(randomforest_binary_classifier)

##############################################################################

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata2(num_rows)

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=1/3,
    validation=1/3,
    testing=1/3,
    )

randomforest_binary_classifier = BinaryRandomForest(
    tabular_dataset,
    :y,
    )

@test(
    typeof(randomforest_binary_classifier) <:
        AbstractSingleLabelBinaryClassifier
    )

x = performance(randomforest_binary_classifier)

##############################################################################

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata3(num_rows)

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.7,
    testing=0.3,
    )

randomforest_binary_classifier = BinaryRandomForest(
    tabular_dataset,
    :deathoutcome,
    )

@test(
    typeof(randomforest_binary_classifier) <:
        AbstractSingleLabelBinaryClassifier
    )

performance(randomforest_binary_classifier)
