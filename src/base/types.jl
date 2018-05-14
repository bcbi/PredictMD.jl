abstract type AbstractEstimator end

abstract type AbstractFeatureContrasts end

abstract type AbstractPipeline end

abstract type AbstractTransformer end

const Fittable = Union{AbstractEstimator,AbstractPipeline,AbstractTransformer}
