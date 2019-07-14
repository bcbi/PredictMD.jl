import Combinatorics
import StatsModels

"""
"""
function generate_formula(lhs::AbstractVector{<:StatsModels.AbstractTerm},
                          rhs::AbstractVector{<:StatsModels.AbstractTerm})
    lhs_deepcopy = deepcopy(lhs)
    rhs_deepcopy = deepcopy(rhs)
    lhs_sum = sum(lhs_deepcopy)
    rhs_sum = sum(rhs_deepcopy)
    result = lhs_sum ~ rhs_sum
    return result
end

"""
"""
function generate_formula(
        dependent_variable::Symbol,
        independent_variables::AbstractVector{<:Symbol};
        intercept::Bool = true,
        interactions::Integer = 1,
        )
    result = generate_formula(
        [dependent_variable],
        independent_variables;
        intercept = intercept,
        interactions = interactions,
        )
    return result
end

"""
"""
function generate_formula(
        dependent_variables::AbstractVector{<:Symbol},
        independent_variables::AbstractVector{<:Symbol};
        intercept::Bool = true,
        interactions::Integer = 1,
        )
    if length(dependent_variables) < 1
        error("length(dependent_variables) must be >= 1")
    end
    if length(independent_variables) < 1
        error("length(independent_variables) must be >= 1")
    end
    if interactions < 1
        error("interactions must be >= 1")
    end
    if interactions > length(independent_variables)
        error("interactions must be <= the number of independent variable")
    end
    if intercept
        intercept_term = StatsModels.term(1)
    else
        intercept_term = StatsModels.term(0)
    end
    lhs_terms = Vector{StatsModels.AbstractTerm}(undef, 0)
    for dep_var in deepcopy(dependent_variables)
        push!(lhs_terms, StatsModels.term(dep_var))
    end
    rhs_terms = Vector{StatsModels.AbstractTerm}(undef, 0)
    push!(rhs_terms, intercept_term)
    for interaction_term in generate_interaction_terms_up_to_level(
            deepcopy(independent_variables),
            interactions)
        push!(rhs_terms, interaction_term)
    end
    result = generate_formula(lhs_terms, rhs_terms)
    return result
end

function generate_interaction_terms_up_to_level(
        xs::AbstractVector{<:Symbol},
        interactions::Integer,
        )
    all_interaction_terms = Vector{StatsModels.AbstractTerm}(undef, 0)
    for level = 1:interactions
        append!(all_interaction_terms,
                generate_interaction_terms_at_level(xs,level))
    end
    unique!(all_interaction_terms)
    return all_interaction_terms
end

function generate_interaction_terms_at_level(
        xs::AbstractVector{<:Symbol},
        level::Integer,
        )
    interaction_sets = collect(
        Combinatorics.combinations(
            xs,
            level,
            )
        )
    interaction_terms = Vector{StatsModels.AbstractTerm}(undef, 0)
    for interaction_set in interaction_sets
        push!(interaction_terms,
              reduce(&, StatsModels.term.(interaction_set)))
    end
    unique!(interaction_terms)
    return interaction_terms
end
