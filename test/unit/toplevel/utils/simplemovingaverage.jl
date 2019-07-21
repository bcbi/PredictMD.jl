import PredictMD
import Test

Test.@test_throws ErrorException PredictMD.simple_moving_average([], -1)
