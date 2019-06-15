abstract type Fittable end

"""
    AbstractPlot{T}
"""
abstract type AbstractPlot{T} end

"""
    AbstractEstimator
"""
abstract type AbstractEstimator <: Fittable end

"""
    AbstractFeatureContrasts
"""
abstract type AbstractFeatureContrasts end

abstract type AbstractNonExistentFeatureContrasts <: AbstractFeatureContrasts
end

"""
    AbstractPipeline
"""
abstract type AbstractPipeline <: Fittable end

"""
    AbstractTransformer
"""
abstract type AbstractTransformer <: Fittable end

abstract type AbstractNonExistentUnderlyingObject end

