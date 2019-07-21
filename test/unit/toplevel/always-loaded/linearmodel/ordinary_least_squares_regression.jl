import PredictMD
import Test

Test.@test_throws ErrorException PredictMD.simple_linear_regression([1, 2], [])
Test.@test_throws ErrorException PredictMD.simple_linear_regression([], [])
