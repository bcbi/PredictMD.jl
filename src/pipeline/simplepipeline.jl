abstract type AbstractSimplePipeline <: AbstractPipeline
end

struct SimplePipeline <: AbstractSimplePipeline
    name::T1 where T1 <: AbstractString
    objectsvector::T2 where T2 <: VectorOfAbstractASBObjects
    underlyingobjectindex::T3 where T3 <: Integer
    valuehistoriesobjectindex::T4 where T4 <: Integer

    function SimplePipeline(
            objectsvector::VectorOfAbstractASBObjects;
            name::AbstractString = "",
            underlyingobjectindex::Integer = 0,
            valuehistoriesobjectindex::Integer = 0,
            )
        if length(objectsvector) == 0
            error("input vector must be non-empty")
        end
        result = new(
            name,
            objectsvector,
            underlyingobjectindex,
            valuehistoriesobjectindex,
            )
        return result
    end
end

function underlying(x::AbstractSimplePipeline)
    if x.underlyingobjectindex > 0
        result = underlying(x.objectsvector[x.underlyingobjectindex])
        return result
    else
        error(
            string(
                "Sorry, I could not access the underlying object ",
                "for this pipeline.",
                )
            )
    end
end

function valuehistories(x::AbstractSimplePipeline)
    if x.valuehistoriesobjectindex > 0
        result =
            valuehistories(x.objectsvector[x.valuehistoriesobjectindex])
        return result
    else
        error(
            string(
                "Sorry, I could not access value histories ",
                "for this pipeline.",
                )
            )
    end
end

function fit!(
        simplepipeline::SimplePipeline,
        features,
        labels;
        kwargs...
        )
    pipelineobjects = simplepipeline.objectsvector
    numpipelineobjects = length(pipelineobjects)
    if numpipelineobjects==0
        error("numpipelineobjects==0")
    end
    output = fit!(pipelineobjects[1], features, labels; kwargs...)
    for i = 2:numpipelineobjects
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = fit!(pipelineobjects[i], input...; kwargs...)
    end
    return output
end

function predict(
        simplepipeline::SimplePipeline,
        features;
        kwargs...
        )
    pipelineobjects = simplepipeline.objectsvector
    numpipelineobjects = length(pipelineobjects)
    if numpipelineobjects==0
        error("numpipelineobjects==0")
    end
    output = predict(pipelineobjects[1], features; kwargs...)
    for i = 2:numpipelineobjects
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = predict(pipelineobjects[i], input...; kwargs...)
    end
    return output
end

function predict_proba(
        simplepipeline::SimplePipeline,
        features;
        kwargs...
        )
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
        output = predict_proba(pipelineobjects[i], input...; kwargs...)
    end
    return output
end
