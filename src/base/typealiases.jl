import MLBase

const Fittable = Union{AbstractEstimator,AbstractPipeline,AbstractTransformer}

const FittableArray = AbstractArray{Fittable}
const FittableVector = AbstractVector{Fittable}
const FittableMatrix = AbstractMatrix{Fittable}

const ROCNumsArray = AbstractArray{T} where T <: MLBase.ROCNums
const ROCNumsVector = AbstractVector{T} where T <: MLBase.ROCNums
const ROCNumsMatrix = AbstractMatrix{T} where T <: MLBase.ROCNums

const StringArray = AbstractArray{T} where T <: AbstractString
const StringVector = AbstractVector{T} where T <: AbstractString
const StringMatrix = AbstractMatrix{T} where T <: AbstractString

const SymbolArray = AbstractArray{T} where T <: Symbol
const SymbolVector = AbstractVector{T} where T <: Symbol
const SymbolMatrix = AbstractMatrix{T} where T <: Symbol

