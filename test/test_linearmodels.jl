# srand(999)
#
# import StatsBase
#
# num_rows1 = 5_000
# dataframe1, label_variables1, feature_variables1 =
#     AluthgeSinhaBase.generatefaketabulardata1(num_rows1)
#
# countmap(dataframe1[:mylabel1])
#
# tabular_dataset1 = HoldoutTabularDataset(
#     dataframe1;
#     data_name = "data set no. 1",
#     label_variables = label_variables1,
#     feature_variables = feature_variables1,
#     training=0.5,
#     validation=0.2,
#     testing=0.3,
#     )
#
# logistic_binary_classifier1 = BinaryLogistic(
#     tabular_dataset1,
#     :mylabel1;
#     model_name = "logistic no. 1",
#     )
#
# logistic_binary_classifier1_perf =
#     ModelPerformance(logistic_binary_classifier1)
#
# classifierhistograms(logistic_binary_classifier1_perf)
#
# plots(logistic_binary_classifier1_perf)
#
# ##############################################################################
#
# num_rows2 = 5_000
# dataframe2, label_variables2, feature_variables2 =
#     AluthgeSinhaBase.generatefaketabulardata2(num_rows2)
#
# tabular_dataset2 = HoldoutTabularDataset(
#     dataframe2;
#     data_name = "data set no. 2",
#     label_variables = label_variables2,
#     feature_variables = feature_variables2,
#     training=1/3,
#     validation=1/3,
#     testing=1/3,
#     )
#
# logistic_binary_classifier2 = BinaryLogistic(
#     tabular_dataset2,
#     :y;
#     model_name = "logistic no. 2",
#     )
#
# logistic_binary_classifier2_perf =
#     ModelPerformance(logistic_binary_classifier2)
#
# classifierhistograms(logistic_binary_classifier2_perf)
#
# plots(logistic_binary_classifier2_perf)
#
# ##############################################################################
#
# num_rows3 = 5_000
# dataframe3, label_variables3, feature_variables3 =
#     AluthgeSinhaBase.generatefaketabulardata3(num_rows3)
#
# tabular_dataset3 = HoldoutTabularDataset(
#     dataframe3;
#     data_name = "data set no. 3",
#     label_variables = label_variables3,
#     feature_variables = feature_variables3,
#     training=0.7,
#     testing=0.3,
#     )
#
# logistic_binary_classifier3 = BinaryLogistic(
#     tabular_dataset3,
#     :deathoutcome;
#     model_name = "logistic no. 3",
#     )
#
# logistic_binary_classifier3_perf =
#     ModelPerformance(logistic_binary_classifier3)
#
# classifierhistograms(logistic_binary_classifier3_perf)
#
# plots(logistic_binary_classifier3_perf)
#
# ##############################################################################
#
# plots(
#     [
#         logistic_binary_classifier1_perf,
#         logistic_binary_classifier2_perf,
#         logistic_binary_classifier3_perf,
#         ],
#     )
