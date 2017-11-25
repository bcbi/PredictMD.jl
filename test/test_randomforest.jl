srand(999)

using DataFrames
using StatsBase

num_rows1 = 5_000
dataframe1, label_variables1, feature_variables1 =
    AluthgeSinhaBase.generatefaketabulardata1(num_rows1)

countmap(dataframe1[:mylabel1])

tabular_dataset1 = HoldoutTabularDataset(
    dataframe1;
    label_variables = label_variables1,
    feature_variables = feature_variables1,
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

randomforest_binary_classifier1 = BinaryRandomForest(
    tabular_dataset1,
    :mylabel1,
    )

randomforest_binary_classifier1_perf =
    ModelPerformance(randomforest_binary_classifier1)

classifierhistograms(randomforest_binary_classifier1_perf)

plots(randomforest_binary_classifier1_perf)

##############################################################################

num_rows2 = 5_000
dataframe2, label_variables2, feature_variables2 =
    AluthgeSinhaBase.generatefaketabulardata2(num_rows2)

tabular_dataset2 = HoldoutTabularDataset(
    dataframe2;
    label_variables = label_variables2,
    feature_variables = feature_variables2,
    training=1/3,
    validation=1/3,
    testing=1/3,
    )

randomforest_binary_classifier2 = BinaryRandomForest(
    tabular_dataset2,
    :y,
    )

randomforest_binary_classifier2_perf =
    ModelPerformance(randomforest_binary_classifier2)

classifierhistograms(randomforest_binary_classifier2_perf)

plots(randomforest_binary_classifier2_perf)

##############################################################################

num_rows3 = 5_000
dataframe3, label_variables3, feature_variables3 =
    AluthgeSinhaBase.generatefaketabulardata3(num_rows3)

tabular_dataset3 = HoldoutTabularDataset(
    dataframe3;
    label_variables = label_variables3,
    feature_variables = feature_variables3,
    training=0.7,
    testing=0.3,
    )

randomforest_binary_classifier3 = BinaryRandomForest(
    tabular_dataset3,
    :deathoutcome,
    )

randomforest_binary_classifier3_perf =
    ModelPerformance(randomforest_binary_classifier3)

classifierhistograms(randomforest_binary_classifier3_perf)

plots(randomforest_binary_classifier3_perf)
