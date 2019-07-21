import PredictMD
import Test

a = PredictMD.predictionsassoctodataframe(Dict(:x => [0.3], :y => [0.7]), Symbol[])
Test.@test a[1, :x] == 0.3
Test.@test a[1, :y] == 0.7
