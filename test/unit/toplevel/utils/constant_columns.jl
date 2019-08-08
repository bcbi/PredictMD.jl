import DataFrames
import PredictMD
import Test

x = Union{Missing, String}["foo", "bar", "foo", missing, "bar"]

Test.@test(
    length(keys(PredictMD.get_countmap(x; skip_missings = true))) == 2
    )
Test.@test(
    length(keys(PredictMD.get_countmap(x; skip_missings = false))) == 3
    )
Test.@test(
    length(keys(PredictMD.get_countmap_skip_missings(x))) == 2
    )
Test.@test(
    length(keys(PredictMD.get_countmap_include_missings(x))) == 3
    )

Test.@test(
    length(PredictMD.get_unique_values(x; skip_missings = true)) == 2
    )
Test.@test(
    length(PredictMD.get_unique_values(x; skip_missings = false)) == 3
    )
Test.@test(
    length(PredictMD.get_unique_values_skip_missings(x)) == 2
    )
Test.@test(
    length(PredictMD.get_unique_values_include_missings(x)) == 3
    )

Test.@test(
    PredictMD.get_number_of_unique_values(x; skip_missings = true) == 2
    )
Test.@test(
    PredictMD.get_number_of_unique_values(x; skip_missings = false) == 3
    )
Test.@test(
    PredictMD.get_number_of_unique_values_skip_missings(x) == 2
    )
Test.@test(
    PredictMD.get_number_of_unique_values_include_missings(x) == 3
    )

df = DataFrames.DataFrame()
df[:a] = [1,2,3,4,5,6,7]
df[:b] = [1,1,1,1,1,1,1]
df_constant_cols = PredictMD.find_constant_columns(df)
Test.@test length(df_constant_cols) == 1
Test.@test df_constant_cols == [:b]
Test.@test all(df_constant_cols .== [:b])
