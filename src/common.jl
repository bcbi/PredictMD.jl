abstract type AbstractASBObject
end

function underlying(x::T) where T <: AbstractASBObject
    return Nullable()
end

const ArrayOfAbstractASBObjects =
    AbstractArray{T, N} where T <: AbstractASBObject where N <: Integer
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
