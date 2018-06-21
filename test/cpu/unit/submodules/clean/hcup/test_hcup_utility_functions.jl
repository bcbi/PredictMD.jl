import PredictMD
import PredictMD.Clean

Base.Test.@test(
    PredictMD.Clean.x_contains_y("abc", ["xyz", "abc", "123",])
    )

Base.Test.@test(
    !PredictMD.Clean.x_contains_y("abc", ["xyz", "opqrst", "123",])
    )

Base.Test.@test(
    PredictMD.Clean.symbol_begins_with(:abcdefg, "abc")
    )

Base.Test.@test(
    !PredictMD.Clean.symbol_begins_with(:abcdefg, "xyz")
    )
