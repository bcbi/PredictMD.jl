abstract type AbstractContrasts end

abstract type AbstractEstimator end

abstract type AbstractPipeline end

abstract type AbstractTransformer end

const Fittable = Union{AbstractEstimator,AbstractPipeline,AbstractTransformer}
