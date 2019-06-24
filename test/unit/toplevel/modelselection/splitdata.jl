features_df = DataFrames.DataFrame()
labels_df = DataFrames.DataFrame()
labels_df[:y] = [1,2,3]

Test.@test_throws(ErrorException, PredictMD.split_data(features_df,
                                                        labels_df,
                                                        2.0))

Test.@test_throws(ErrorException, PredictMD.split_data(features_df,
                                                        labels_df,
                                                        0.5))
