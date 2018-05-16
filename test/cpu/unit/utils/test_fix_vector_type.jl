import Base.Test

vector_1 = []
push!(vector_1, Float64(1.0))
push!(vector_1, Float64(2.0))
push!(vector_1, Float64(3.0))
Base.Test.@test(typeof(vector_1) <: Vector{Any})

vector_2 = PredictMD.fix_vector_type(vector_1)
Base.Test.@test(typeof(vector_2) <: Vector{Float64})

vector_3 = PredictMD.fix_vector_type(vector_2)
Base.Test.@test(typeof(vector_3) <: Vector{Float64})

vector_4 = PredictMD.fix_vector_type(vector_3)
Base.Test.@test(typeof(vector_4) <: Vector{Float64})
