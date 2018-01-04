immutable ImmutableSimpleLinearPipeline <: AbstractCompositeObject
    name::T1 where T1 <: AbstractString
    objectsvector::T2 where T2 <: AbstractObjectVector
end

function ImmutableSimpleLinearPipeline(
        objectsvector::AbstractObjectVector;
        name::AbstractString = "",
        )
    result = ImmutableSimpleLinearPipeline(
        name,
        objectsvector,
        )
    return result
end

function underlying(x::ImmutableSimpleLinearPipeline)
    allunderlyings = [underlying(o) for o in x.objectsvector]
    result = allunderlyings[find(allunderlyings .!= nothing)]
    return result
end

function valuehistories(x::ImmutableSimpleLinearPipeline)
    allvaluehistories = [valuehistories(o) for i in x.objectsvector]
    result = allvaluehistories[find(allvaluehistories .!= nothing)]
    return result
end

function fit!(
        simplelinearpipeline::ImmutableSimpleLinearPipeline,
        varargs...;
        kwargs...
        )
    output = fit!(
        simplelinearpipeline.objectsvector[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = fit!(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end

function predict(
        simplelinearpipeline::ImmutableSimpleLinearPipeline,
        varargs...;
        kwargs...
        )
    output = predict(
        simplelinearpipeline.objectsvector[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = predict(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end

function predict_proba(
        simplelinearpipeline::ImmutableSimpleLinearPipeline,
        varargs...;
        kwargs...
        )
    output = predict_proba(
        simplelinearpipeline.objectsvector[1],
        varargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = output
        if !(typeof(input) <: Tuple)
            input = tuple(input)
        end
        output = predict_proba(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end
