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
