import Base.Test

dict_1 = Dict()
Dict(Symbol(:x)) = Float64(1.1)
Dict(Symbol(:y)) = Float64(2.2)
Dict(Symbol(:z)) = Float64(3.3)
Base.Test.@test(typeof(dict_1) <: Dict{Any, Any})

dict_2 = fix_dict_type(dict_1)
Base.Test.@test(typeof(dict_1_fixed) <: Dict{Symbol, Float64})

dict_3 = fix_dict_type(dict_2)
Base.Test.@test(typeof(dict_3) <: Dict{Symbol, Float64})

dict_4 = fix_dict_type(dict_3)
Base.Test.@test(typeof(dict_4) <: Dict{Symbol, Float64})
