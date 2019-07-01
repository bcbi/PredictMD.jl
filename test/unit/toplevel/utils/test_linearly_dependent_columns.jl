import DataFrames
import PredictMD
import Random
import Test

Test.@testset "linearly independent" begin
    num_rows = 1_000
    x = randn(Random.MersenneTwister(1), num_rows)
    x1 = randn(Random.MersenneTwister(2), num_rows)
    x11 = randn(Random.MersenneTwister(3), num_rows)
    y = randn(Random.MersenneTwister(4), num_rows)
    y1 = randn(Random.MersenneTwister(5), num_rows)
    y11 = randn(Random.MersenneTwister(6), num_rows)
    z = randn(Random.MersenneTwister(7), num_rows)
    z1 = randn(Random.MersenneTwister(8), num_rows)
    z11 = randn(Random.MersenneTwister(9), num_rows)
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
end

Test.@testset "linearly dependent" begin
    num_rows = 1_000
    x = randn(Random.MersenneTwister(10), num_rows)
    x1 = randn(Random.MersenneTwister(11), num_rows)
    x11 = randn(Random.MersenneTwister(12), num_rows)
    y = randn(Random.MersenneTwister(13), num_rows)
    y1 = randn(Random.MersenneTwister(14), num_rows)
    y11 = randn(Random.MersenneTwister(15), num_rows)
    z = 2*x .+ 3*y
    z1 = randn(Random.MersenneTwister(17), num_rows)
    z11 = randn(Random.MersenneTwister(18), num_rows)
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

    DataFrames.deletecols!(df, [:z])
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
end
