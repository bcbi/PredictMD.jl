import DataFrames

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
Test.@test(length(PredictMD.linearly_dependent_columns(df)) == 0)

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
result = PredictMD.linearly_dependent_columns(df)
Test.@test(length(result) == 1)
Test.@test(all(result.==[:x]) || all(result.==[:y]) || all(result.==[:z]))

DataFrames.delete!(df, :z)
Test.@test(PredictMD.columns_are_linearly_independent(df))
Test.@test(length(PredictMD.linearly_dependent_columns(df)) == 0)
