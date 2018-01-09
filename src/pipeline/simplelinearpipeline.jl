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

function setfeaturecontrasts!(
        x::ImmutableSimpleLinearPipeline,
        contrasts::AbstractContrasts,
        )
    for i = 1:length(x.objectsvector)
        setfeaturecontrasts!(x, contrasts)
    end
    return nothing
end

function underlying(
        x::ImmutableSimpleLinearPipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    allunderlyingobjects = [underlying(o) for o in x.objectsvector]
    if saving || loading
    else
        deletenothings!(allunderlyingobjects)
        if length(allunderlyingobjects) == 0
            allunderlyingobjects = nothing
        elseif length() == 1
            allunderlyingobjects = allunderlyingobjects[1]
        else
        end
    end
    return allunderlyingobjects
end

function valuehistories(x::ImmutableSimpleLinearPipeline)
    allvaluehistories =
        [valuehistories(o) for o in x.objectsvector]
    allvaluehistoriesminusnothings =
        allvaluehistories[find(allvaluehistories .!= nothing)]
    if length(allvaluehistoriesminusnothings) == 0
        return []
    elseif length(allvaluehistoriesminusnothings) == 1
        return allvaluehistoriesminusnothings[1]
    else
        return allvaluehistoriesminusnothings
    end
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
