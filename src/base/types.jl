##### Beginning of file

"""
    AbstractPlot{T}
"""
abstract type AbstractPlot{T} end

"""
    AbstractEstimator
"""
abstract type AbstractEstimator end

"""
    AbstractFeatureContrasts
"""
abstract type AbstractFeatureContrasts end

abstract type AbstractNonExistentFeatureContrasts <: AbstractFeatureContrasts
end

struct FeatureContrastsNotYetGenerated <: AbstractNonExistentFeatureContrasts
end

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
