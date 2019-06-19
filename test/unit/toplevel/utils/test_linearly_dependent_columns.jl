import DataFrames
import PredictMD
import Test

num_rows = 1_000
x = randn(num_rows)
x1 = randn(num_rows)
x11 = randn(num_rows)
y = randn(num_rows)
y1 = randn(num_rows)
y11 = randn(num_rows)
z = randn(num_rows)
z1 = randn(num_rows)
z11 = randn(num_rows)
df = DataFrames.DataFrame(
    :x => x,
    :x1 => x1,
    :x11 => x11,
    :y => y,
    :y1 => y1,
    :y11 => y11,
    :z => z,
    :z1 => z1,
    :z11 => z11,
    )
Test.@test(PredictMD.columns_are_linearly_independent(df))
Test.@test(
    PredictMD.columns_are_linearly_independent(
        df,
        [:x, :x1, :x11, :y, :y1, :y11, :z, :z1, :z11],
        )
    )
Test.@test(length(PredictMD.linearly_dependent_columns(df)) == 0)
Test.@test(
    length(
        PredictMD.linearly_dependent_columns(
            df,
            [:x, :x1, :x11, :y, :y1, :y11, :z, :z1, :z11],
            ),
        ) == 0
    )

num_rows = 1_000
x = randn(num_rows)
x1 = randn(num_rows)
x11 = randn(num_rows)
y = randn(num_rows)
y1 = randn(num_rows)
y11 = randn(num_rows)
z = 2*x .+ 3*y
z1 = randn(num_rows)
z11 = randn(num_rows)
df = DataFrames.DataFrame(
    :x => x,
    :x1 => x1,
    :x11 => x11,
    :y => y,
    :y1 => y1,
    :y11 => y11,
    :z => z,
    :z1 => z1,
    :z11 => z11,
    )
Test.@test(!PredictMD.columns_are_linearly_independent(df))
Test.@test(
    !PredictMD.columns_are_linearly_independent(
        df,
        [:x, :x1, :x11, :y, :y1, :y11, :z, :z1, :z11],
        )
    )
Test.@test(length(PredictMD.linearly_dependent_columns(df)) == 1)
Test.@test(
    length(
        PredictMD.linearly_dependent_columns(
            df,
            [:x, :x1, :x11, :y, :y1, :y11, :z, :z1, :z11],
            )
        ) == 1
    )
result1 = PredictMD.linearly_dependent_columns(df)
result2 = PredictMD.linearly_dependent_columns(
    df,
    [:x, :x1, :x11, :y, :y1, :y11, :z, :z1, :z11],
    )
Test.@test(
    all(result1.==[:x]) || all(result1.==[:y]) || all(result1.==[:z])
    )
Test.@test(
    all(result2.==[:x]) || all(result2.==[:y]) || all(result2.==[:z])
    )

DataFrames.delete!(df, :z)
Test.@test(PredictMD.columns_are_linearly_independent(df))
Test.@test(
    PredictMD.columns_are_linearly_independent(
        df,
        [:x, :x1, :x11, :y, :y1, :y11, :z1, :z11],
        )
    )
Test.@test(length(PredictMD.linearly_dependent_columns(df)) == 0)
Test.@test(
    length(
        PredictMD.linearly_dependent_columns(
            df,
            [:x, :x1, :x11, :y, :y1, :y11, :z1, :z11],
            )
        ) == 0
    )
