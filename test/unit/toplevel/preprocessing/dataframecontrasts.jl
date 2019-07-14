import DataFrames
import PredictMD
import Test

a = DataFrames.DataFrame()
a[:x] = ["foo", "foo", "foo", "bar", "bar", "bar"]
contrasts = PredictMD.DataFrameFeatureContrasts(a, [:x])
transformer = PredictMD.MutableDataFrame2DecisionTreeTransformer([:x], :y)
PredictMD.set_feature_contrasts!(transformer, contrasts)

Test.@test length(PredictMD.transform(transformer, a)) == 6

b = DataFrames.DataFrame()
b[:x] = ["bar", "foo"]
Test.@test length(PredictMD.transform(transformer, b)) == 2

c = DataFrames.DataFrame()
c[:x] = ["foo", "bar", "baz"]
Test.@test_throws KeyError PredictMD.transform(transformer, c)
