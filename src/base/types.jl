##### Beginning of file

"""
    AbstractEstimator
"""
abstract type AbstractEstimator end

"""
    AbstractFeatureContrasts
"""
abstract type AbstractFeatureContrasts end

"""
    AbstractPipeline
"""
abstract type AbstractPipeline end

"""
    AbstractTransformer
"""
abstract type AbstractTransformer end

const Fittable = Union{AbstractEstimator,AbstractPipeline,AbstractTransformer}

"""
    Fittable
"""
Fittable

abstract type AbstractNonExistentUnderlyingObject end

struct FitNotYetRunUnderlyingObject <: AbstractNonExistentUnderlyingObject
end

struct FitFailedUnderlyingObject <: AbstractNonExistentUnderlyingObject
end

##### End of file
