abstract type AbstractSimplePipeline <: AbstractPipeline
end

struct SimplePipeline <: AbstractSimplePipeline
    name::N where N <: AbstractString
    objectsvector::T1 where T1 <: VectorOfAbstractASBObjects

    function SimplePipeline(
            objectsvector::TT1;
            name::NN = "",
            ) where
            TT1 <: VectorOfAbstractASBObjects where
            NN <: AbstractString
        if length(objectsvector) == 0
            error("input vector must be non-empty")
        end
        return new(name, objectsvector)
    end
end

function underlying(
        simplepipeline::T1,
        ) where
        T1 <: AbstractSimplePipeline
    objectsvector = simplepipeline.objectsvector
    result = [underlying(x) for x in objectsvector]
    return result
end

function fit!(
        simplepipeline::T1,
        features::T2,
        labels::T3,
        ) where
        T1 <: SimplePipeline where
        T2 where
        T3
    pipelineobjects = simplepipeline.objectsvector
    numpipelineobjects = length(pipelineobjects)
    if numpipelineobjects==0
        error("numpipelineobjects==0")
    end
    output = fit!(pipelineobjects[1], features, labels)
    for i = 2:numpipelineobjects
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = fit!(pipelineobjects[i], input...)
    end
    return output
end

function predict(
        simplepipeline::T1,
        features::T2,
        ) where
        T1 <: SimplePipeline where
        T2
    pipelineobjects = simplepipeline.objectsvector
    numpipelineobjects = length(pipelineobjects)
    if numpipelineobjects==0
        error("numpipelineobjects==0")
    end
    output = predict(pipelineobjects[1], features)
    for i = 2:numpipelineobjects
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = predict(pipelineobjects[i], input...)
    end
    return output
end

function predict_proba(
        simplepipeline::T1,
        features::T2,
        ) where
        T1 <: SimplePipeline where
        T2
    pipelineobjects = simplepipeline.objectsvector
    numpipelineobjects = length(pipelineobjects)
    if numpipelineobjects==0
        error("numpipelineobjects==0")
    end
    output = predict_proba(pipelineobjects[1], features)
    for i = 2:numpipelineobjects
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = predict_proba(pipelineobjects[i], input...)
    end
    return output
end
