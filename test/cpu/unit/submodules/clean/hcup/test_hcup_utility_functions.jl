##### Beginning of file

import PredictMD
import PredictMD.Cleaning

Base.Test.@test(
    PredictMD.Cleaning.x_contains_y("abc", ["xyz", "abc", "123",])
    )

Base.Test.@test(
    !PredictMD.Cleaning.x_contains_y("abc", ["xyz", "opqrst", "123",])
    )

Base.Test.@test(
    PredictMD.Cleaning.symbol_begins_with(:abcdefg, "abc")
    )

Base.Test.@test(
    !PredictMD.Cleaning.symbol_begins_with(:abcdefg, "xyz")
    )

##### End of file
