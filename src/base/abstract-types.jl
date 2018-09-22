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

##### End of file
