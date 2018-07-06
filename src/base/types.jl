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

##### End of file
