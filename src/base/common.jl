import MLBase

const ArrayOfSymbols =
    AbstractArray{T, N} where T <: Symbol where N
const VectorOfSymbols =
    AbstractArray{T, 1} where T <: Symbol
const MatrixOfSymbolms =
    AbstractArray{T, 2} where T <: Symbol

const ArrayOfMLBaseROCNums =
    AbstractArray{T, N} where T <: MLBase.ROCNums where N
const VectorOfMLBaseROCNums =
    AbstractArray{T, 1} where T <: MLBase.ROCNums
const MatrixOfMLBaseROCNums =
    AbstractArray{T, 2} where T <: MLBase.ROCNums

abstract type AbstractASBObject
end

const ArrayOfAbstractASBObjects =
    AbstractArray{T, N} where T <: AbstractASBObject where N
const VectorOfAbstractASBObjects =
    AbstractArray{T, 1} where T <: AbstractASBObject
const MatrixOfAbstractASBObjects =
    AbstractArray{T, 2} where T <: AbstractASBObject

abstract type AbstractEnsemble <: AbstractASBObject
end

abstract type AbstractPipeline <: AbstractASBObject
end

abstract type AbstractTransformer <: AbstractASBObject
end

abstract type AbstractEstimator <: AbstractASBObject
end

abstract type AbstractClassifier <: AbstractEstimator
end

abstract type AbstractRegression <: AbstractEstimator
end
