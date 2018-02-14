import MLBase

const AbstractObjectArray = AbstractArray{T} where T <: AbstractObject
const AbstractObjectVector = AbstractVector{T} where T <: AbstractObject
const AbstractObjectMatrix = AbstractMatrix{T} where T <: AbstractObject

const ROCNumsArray = AbstractArray{T} where T <: MLBase.ROCNums
const ROCNumsVector = AbstractVector{T} where T <: MLBase.ROCNums
const ROCNumsMatrix = AbstractMatrix{T} where T <: MLBase.ROCNums

const StringArray = AbstractArray{T} where T <: AbstractString
const StringVector = AbstractVector{T} where T <: AbstractString
const StringMatrix = AbstractMatrix{T} where T <: AbstractString


const SymbolArray = AbstractArray{T} where T <: Symbol
const SymbolVector = AbstractVector{T} where T <: Symbol
const SymbolMatrix = AbstractMatrix{T} where T <: Symbol
