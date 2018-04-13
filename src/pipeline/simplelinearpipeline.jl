struct ImmutableSimpleLinearPipeline <: AbstractCompositeObject
    name::T1 where T1 <: AbstractString
    objectsvector::T2 where T2 <: FittableVector
end

function ImmutableSimpleLinearPipeline(
        objectsvector::FittableVector;
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
        setfeaturecontrasts!(x.objectsvector[i], contrasts)
    end
    return nothing
end

function get_underlying(
        x::ImmutableSimpleLinearPipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    allunderlying = [
        get_underlying(
            o;
            saving=saving,
            loading=loading,
            ) for o in x.objectsvector
        ]
    if saving || loading
    else
        deletenothings!(allunderlying)
        if length(allunderlying) == 0
            allunderlying = nothing
        elseif length(allunderlying) == 1
            allunderlying = allunderlying[1]
        else
        end
    end
    return allunderlying
end

function set_underlying!(
        x::ImmutableSimpleLinearPipeline,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    if length(x.objectsvector) != length(object)
        error("length(x) != length(object)")
    end
    for i = 1:length(x.objectsvector)
        set_underlying!(
            x.objectsvector[i],
            object[i];
            saving=saving,
            loading=loading,
            )
    end
    return nothing
end

function gethistory(
        x::ImmutableSimpleLinearPipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    allhistory = [
        gethistory(
            o;
            saving = saving,
            loading = loading,
            ) for o in x.objectsvector
        ]
    if saving || loading
    else
        deletenothings!(allhistory)
        if length(allhistory) == 0
            allhistory = nothing
        elseif length(allhistory) == 1
            allhistory = allhistory[1]
        else
        end
    end
    return allhistory
end

function sethistory!(
        x::ImmutableSimpleLinearPipeline,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    if length(x.objectsvector) != length(h)
        error("length(x.objectsvector) != length(h)")
    end
    for i = 1:length(x.objectsvector)
        sethistory!(
            x.objectsvector[i],
            h[i];
            saving=saving,
            loading=loading,
            )
    end
    return nothing
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
