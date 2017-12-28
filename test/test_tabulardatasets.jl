# srand(999)
#
# using DataFrames
#
# d = DataFrame()
#
# d[:a] = [
#     "oNe",
#     "tWo",
#     "thrEe",
#     "foUr",
#     "fiVe",
#     "sIx",
#     "sevEn",
#     "eigHt",
#     "niNe",
#     ]
#
# d[:b] = 1:10:81
#
# dataset = HoldoutTabularDataset(
#     d;
#     label_variables = [:b],
#     feature_variables = [:a],
#     training = 1.0,
#     )
#
# num_rows = dataset.blobs[:num_rows]
# recordid_fieldname = dataset.blobs[:recordid_fieldname]
#
# recordidlist = [3, 1, 2, 7]
#
# requesteddata = getdata(
#     dataset;
#     recordidlist = recordidlist,
#     features = true,
#     )
#
# @test(all(requesteddata[:a].==["thrEe","oNe","tWo","sevEn"]))
#
# ##############################################################################
#
# num_rows = 5_000
# dataframe, label_variables, feature_variables =
#     AluthgeSinhaBase.generatefaketabulardata1(num_rows)
# countmap(dataframe[:mylabel1])
#
# tabular_dataset = HoldoutTabularDataset(
#     dataframe;
#     label_variables = label_variables,
#     feature_variables = feature_variables,
#     training=0.5,
#     validation=0.2,
#     testing=0.3,
#     )
#
# @test(typeof(tabular_dataset) <: AbstractDataset)
# @test(typeof(tabular_dataset) <: AbstractTabularDataset)
# @test(typeof(tabular_dataset) <: AbstractHoldoutTabularDataset)
# @test(typeof(tabular_dataset) <: HoldoutTabularDataset)
#
# ##############################################################################
#
# dataframe = DataFrame()
# dataframe[:a] = [1,2,3,4,5]
# dataframe[:b] = [6,7,8,9,10]
# dataframe[:y] = [11,12,13,14,15]
# dataframe[4,:b] = NA
# @test_throws(
#     ErrorException,
#     HoldoutTabularDataset(
#         dataframe;
#         label_variables = [:y],
#         feature_variables = [:a, :b],
#         training=0.5,
#         validation=0.2,
#         testing=0.3,
#         ),
#     )
