import PredictMDAPI

struct Foo_Fittable{T} <: PredictMDAPI.AbstractFittable
    x::T
end


struct Bar_Fittable{T} <: PredictMDAPI.AbstractFittable
    x::T
end


struct Baz_Fittable{T} <: PredictMDAPI.AbstractFittable
    x::T
end
