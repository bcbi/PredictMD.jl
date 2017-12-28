# srand(999)
#
# using DataFrames
# using StatsBase
#
# num_rows1 = 5_000
# dataframe1, label_variables1, feature_variables1 =
#     AluthgeSinhaBase.generatefaketabulardata1(num_rows1)
#
# countmap(dataframe1[:mylabel1])
#
# tabular_dataset1 = HoldoutTabularDataset(
#     dataframe1;
#     label_variables = label_variables1,
#     feature_variables = feature_variables1,
#     training=0.5,
#     validation=0.2,
#     testing=0.3,
#     )
#
# svm_binary_classifier1 = BinarySVM(
#     tabular_dataset1,
#     :mylabel1,
#     )
#
# svm_binary_classifier1_perf =
#     ModelPerformance(svm_binary_classifier1)
#
# classifierhistograms(svm_binary_classifier1_perf)
#
# plots(svm_binary_classifier1_perf)
#
# ##############################################################################
#
# num_rows2 = 5_000
# dataframe2, label_variables2, feature_variables2 =
#     AluthgeSinhaBase.generatefaketabulardata2(num_rows2)
#
# StatsBase.countmap(dataframe2[:y])
#
# tabular_dataset2 = HoldoutTabularDataset(
#     dataframe2;
#     label_variables = label_variables2,
#     feature_variables = feature_variables2,
#     training=1/3,
#     validation=1/3,
#     testing=1/3,
#     )
#
# svm_binary_classifier2 = BinarySVM(
#     tabular_dataset2,
#     :y,
#     )
#
# svm_binary_classifier2_perf =
#     ModelPerformance(svm_binary_classifier2)
#
# classifierhistograms(svm_binary_classifier2_perf)
#
# plots(svm_binary_classifier2_perf)
#
# ##############################################################################
#
# num_rows3 = 5_000
# dataframe3, label_variables3, feature_variables3 =
#     AluthgeSinhaBase.generatefaketabulardata3(num_rows3)
#
# StatsBase.countmap(dataframe3[:deathoutcome])
#
# tabular_dataset3 = HoldoutTabularDataset(
#     dataframe3;
#     label_variables = label_variables3,
#     feature_variables = feature_variables3,
#     training=0.7,
#     testing=0.3,
#     )
#
# svm_binary_classifier3 = BinarySVM(
#     tabular_dataset3,
#     :deathoutcome,
#     )
#
# svm_binary_classifier3_perf =
#     ModelPerformance(svm_binary_classifier3)
#
# classifierhistograms(svm_binary_classifier3_perf)
#
# plots(svm_binary_classifier3_perf)
