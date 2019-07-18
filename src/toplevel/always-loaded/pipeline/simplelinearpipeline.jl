import MacroTools

"""
"""
function SimplePipeline(
        objectsvector::T;
        name::S = "",
        ) where
        S <: AbstractString where
        T <: AbstractVector{F} where
        F <: AbstractFittable
    result = SimplePipeline{S,T}(name,
                                 objectsvector)
    return result
end

SimplePipeline(x::T) where T = SimplePipeline(T[x])
SimplePipeline(p::SimplePipeline) = p

Base.IteratorEltype(itertype::Type{SimplePipeline{S, T}}) where S where T =
    Base.IteratorEltype(T)
Base.IteratorSize(itertype::Type{SimplePipeline{S, T}}) where S where T =
    Base.IteratorSize(T)
Base.IndexStyle(itertype::Type{SimplePipeline{S, T}}) where S where T =
    Base.IndexStyle(T)

MacroTools.@forward SimplePipeline.objectsvector Base.axes
MacroTools.@forward SimplePipeline.objectsvector Base.eachindex
MacroTools.@forward SimplePipeline.objectsvector Base.eltype
MacroTools.@forward SimplePipeline.objectsvector Base.empty!
MacroTools.@forward SimplePipeline.objectsvector Base.findall
MacroTools.@forward SimplePipeline.objectsvector Base.findfirst
MacroTools.@forward SimplePipeline.objectsvector Base.findlast
MacroTools.@forward SimplePipeline.objectsvector Base.findnext
MacroTools.@forward SimplePipeline.objectsvector Base.findprev
MacroTools.@forward SimplePipeline.objectsvector Base.firstindex
MacroTools.@forward SimplePipeline.objectsvector Base.getindex
MacroTools.@forward SimplePipeline.objectsvector Base.isassigned
MacroTools.@forward SimplePipeline.objectsvector Base.isempty
MacroTools.@forward SimplePipeline.objectsvector Base.iterate
MacroTools.@forward SimplePipeline.objectsvector Base.lastindex
MacroTools.@forward SimplePipeline.objectsvector Base.length
MacroTools.@forward SimplePipeline.objectsvector Base.ndims
MacroTools.@forward SimplePipeline.objectsvector Base.setindex!
MacroTools.@forward SimplePipeline.objectsvector Base.size
MacroTools.@forward SimplePipeline.objectsvector Base.vec
MacroTools.@forward SimplePipeline.objectsvector Base.view

Base.:|>(x::AbstractFittable, y::AbstractFittable) = SimplePipeline(x) |>
                                                     SimplePipeline(y)

# alternatively, we could replace `Union{F1, F2} with `typejoin(F1, F2)`
# function Base.:|>(left::F1, right::F2) where
#         F1 <:AbstractFittable where
#         F2 <:AbstractFittable
#     result = SimplePipeline{String, Vector{Union{F1, F2}}}("", [left]) |>
#              SimplePipeline{String, Vector{Union{F1, F2}}}("", [right])
#     return result
# end

# function Base.:|>(left::SimplePipeline, right::F) where F <: AbstractFittable
#     result = left |> SimplePipeline{String, Vector{F}}("", [right])
#     return result
# end

# function Base.:|>(left::F, right::SimplePipeline) where F <: AbstractFittable
#     result = SimplePipeline{String, Vector{F}}("", [left]) |> right
#     return result
# end

# alternatively, we could replace `Union{F1, F2}` with `typejoin(F1, F2)`
function Base.:|>(p1::SimplePipeline{S1, T1},
                  p2::SimplePipeline{S2, T2}) where
                  S1 where T1 <:AbstractVector{F1} where F1 where
                  S2 where T2 <:AbstractVector{F2} where F2
    length_1 = length(p1)
    length_2 = length(p2)
    new_objectsvector = Vector{Union{F1, F2}}(undef, length_1 + length_2)
    for i = 1:length_1
        new_objectsvector[i] = p1[i]
    end
    for i = 1:length_2
        new_objectsvector[length_1 + i] = p2[i]
    end
    result = SimplePipeline(new_objectsvector;
                            name = string(p1.name, p2.name))
    return result
end

"""
"""
function flatten(::Type{SimplePipeline}, p::SimplePipeline)
    result = _flatten(SimplePipeline, p)
    return result
end

flatten(p::SimplePipeline) = _flatten(SimplePipeline, p::SimplePipeline)

# alternatively, we could replace `Union{typeof.(temp_objects)...}` with
# `typejoin(typeof.(temp_objects)...)`
function _flatten(::Type{SimplePipeline}, p::SimplePipeline)
    temp_names = Vector{Any}(undef, 0)
    temp_objects = Vector{Any}(undef, 0)
    for i = 1:length(p)
        object = p[i]
        push!(temp_names, _flatten_name(SimplePipeline, object))
        append!(temp_objects, _flatten_objects(SimplePipeline, object))
    end
    new_F = Union{typeof.(temp_objects)...}
    new_objects::Vector{new_F} = Vector{new_F}(undef,length(temp_objects))
    for j = 1:length(temp_objects)
        new_objects[j] = temp_objects[j]
    end
    new_name::String = string(p.name, join(temp_names, ""))
    new_pipeline = SimplePipeline(new_objects; name = new_name)
    return new_pipeline
end

_flatten_name(::Type{SimplePipeline}, x) = ""
_flatten_name(::Type{SimplePipeline}, p::SimplePipeline) =
    _flatten(SimplePipeline, p).name

_flatten_objects(::Type{SimplePipeline}, x) = [x]
_flatten_objects(::Type{SimplePipeline}, p::SimplePipeline) =
    _flatten(SimplePipeline, p).objectsvector

"""
"""
function set_max_epochs!(
        p::SimplePipeline,
        new_max_epochs::Integer,
        )
    for i = 1:length(p)
        set_max_epochs!(
            p[i],
            new_max_epochs,
            )
    end
    return nothing
end

"""
"""
function set_feature_contrasts!(
        p::SimplePipeline,
        feature_contrasts::AbstractFeatureContrasts,
        )
    for i = 1:length(p)
        set_feature_contrasts!(p[i], feature_contrasts)
    end
    return nothing
end

"""
"""
function get_underlying(
        p::SimplePipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    underlying = [
        get_underlying(
            o;
            saving=saving,
            loading=loading,
            ) for o in p.objectsvector
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
        p::SimplePipeline;
        saving::Bool = false,
        loading::Bool = false,
        )
    history = [
        get_history(
            o;
            saving = saving,
            loading = loading,
            ) for o in p.objectsvector
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
    for i = 1:length(simplelinearpipeline)
        parse_functions!(simplelinearpipeline[i])
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
        simplelinearpipeline[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline)
        input = tuplify(output)
        output = fit!(
            simplelinearpipeline[i],
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
        simplelinearpipeline[1],
        varargs...;
        kwargs...
        )
    for i = 2:length(simplelinearpipeline)
        input = tuplify(output)
        output = predict(
            simplelinearpipeline[i],
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
        simplelinearpipeline[1],
        varargs...
        )
    for i = 2:length(simplelinearpipeline)
        input = tuplify(output)
        output = predict_proba(
            simplelinearpipeline[i],
            input...;
            kwargs...
            )
    end
    return output
end
