import DataFrames
import PredictMD
import Test

Test.@test_throws(
    ErrorException,
    PredictMD.calculate_smote_pct_under(;pct_over=-111,minority_to_majority_ratio=0.5),
    )

Test.@test_throws(
    ErrorException,
    PredictMD.calculate_smote_pct_under(;pct_over=100,minority_to_majority_ratio=-1.5),
    )

features_df_0rows = DataFrames.DataFrame()
labels_df_0rows = DataFrames.DataFrame()
labels_df_3rows = DataFrames.DataFrame()
labels_df_3rows[:y] = [1,2,3]
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "",
                    minorityclass = "",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_3rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    minority_to_majority_ratio = 1,
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    minority_to_majority_ratio = 1,
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_0rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    minority_to_majority_ratio = 1,
                    ),
    )
Test.@test_throws(
    ErrorException,
    PredictMD.smote(features_df_0rows,
                    labels_df_3rows,
                    Symbol[],
                    :y;
                    majorityclass = "majorityclass",
                    minorityclass = "minorityclass",
                    minority_to_majority_ratio = 1,
                    ),
    )
