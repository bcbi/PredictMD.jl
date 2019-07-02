import PredictMD
import Test

a = Union{String, Missing}["foo", "bar", "foo"]
b = PredictMD.disallowmissing(a)
Test.@test isa(b, Vector{String})
Test.@test b == String["foo", "bar", "foo"]
c = Union{String, Missing}["foo", "bar", missing]
Test.@test_throws MethodError PredictMD.disallowmissing(c)
