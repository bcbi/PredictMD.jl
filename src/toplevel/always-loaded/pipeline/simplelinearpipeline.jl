"""
"""
function SimplePipeline(
        objectsvector::AbstractVector{AbstractFittable};
        name::AbstractString = "",
        )
    result = SimplePipeline(
        name,
        objectsvector,
        )
    return result
end

function Base.:|>(left::AbstractFittable, right::AbstractFittable)
    result = SimplePipeline(AbstractFittable[left]) |>
        SimplePipeline(AbstractFittable[right])
    return result
end

function Base.:|>(left::SimplePipeline, right::AbstractFittable)
    result = left |> SimplePipeline(AbstractFittable[right])
    return result
end

function Base.:|>(left::AbstractFittable, right::SimplePipeline)
    result = SimplePipeline(AbstractFittable[left]) |> right
    return result
end

function Base.:|>(left::SimplePipeline, right::SimplePipeline)
    result = SimplePipeline(
        string(left.name, right.name),
        vcat(left.objectsvector, right.objectsvector),
        )
    return result
end

"""
"""
function set_max_epochs!(
        x::SimplePipeline,
        new_max_epochs::Integer,
        )
    for i = 1:length(x.objectsvector)
        set_max_epochs!(
            x.objectsvector[i],
            new_max_epochs,
            )
    end
    return nothing
end

"""
"""
function set_feature_contrasts!(
        x::SimplePipeline,
        feature_contrasts::AbstractFeatureContrasts,
        )
    for i = 1:length(x.objectsvector)
        set_feature_contrasts!(x.objectsvector[i], feature_contrasts)
    end
    return nothing
end

"""
"""
function get_underlying(
        x::SimplePipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    underlying = [
        get_underlying(
            o;
            saving=saving,
            loading=loading,
            ) for o in x.objectsvector
        ]
    if saving || loading
    else
        delete_nothings!(underlying)
        if length(underlying) == 0
            underlying = nothing
        elseif length(underlying) == 1
            underlying = underlying[1]
        end
    end
    return underlying
end

"""
"""
function get_history(
        x::SimplePipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    history = [
        get_history(
            o;
            saving = saving,
            loading = loading,
            ) for o in x.objectsvector
        ]
    if saving || loading
    else
        delete_nothings!(history)
        if length(history) == 0
            history = nothing
        elseif length(history) == 1
            history = history[1]
        end
    end
    return history
end

"""
"""
function parse_functions!(simplelinearpipeline::SimplePipeline)
    for i = 1:length(simplelinearpipeline.objectsvector)
        parse_functions!(simplelinearpipeline.objectsvector[i])
    end
    return nothing
end

"""
"""
function fit!(
        simplelinearpipeline::SimplePipeline,
        varargs...;
        kwargs...
        )
    output = fit!(
        simplelinearpipeline.objectsvector[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = tuplify(output)
        output = fit!(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end

"""
"""
function predict(
        simplelinearpipeline::SimplePipeline,
        varargs...;
        kwargs...
        )
    output = predict(
        simplelinearpipeline.objectsvector[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = tuplify(output)
        output = predict(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end

"""
"""
function predict_proba(
        simplelinearpipeline::SimplePipeline,
        varargs...;
        kwargs...
        )
    output = predict_proba(
        simplelinearpipeline.objectsvector[1],
        varargs...
        )
    for i = 2:length(simplelinearpipeline.objectsvector)
        input = tuplify(output)
        output = predict_proba(
            simplelinearpipeline.objectsvector[i],
            input...;
            kwargs...
            )
    end
    return output
end