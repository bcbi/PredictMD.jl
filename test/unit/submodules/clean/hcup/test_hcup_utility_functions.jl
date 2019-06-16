import PredictMD
import PredictMD.Cleaning

Test.@test(
    PredictMD.Cleaning.x_contains_y("abc", ["xyz", "abc", "123",])
    )

Test.@test(
    !PredictMD.Cleaning.x_contains_y("abc", ["xyz", "opqrst", "123",])
    )

Test.@test(
    PredictMD.Cleaning.symbol_begins_with(:abcdefg, "abc")
    )

Test.@test(
    !PredictMD.Cleaning.symbol_begins_with(:abcdefg, "xyz")
    )

