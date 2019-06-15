import Combinatorics
import StatsModels

"""
"""
generate_formula(x::AbstractString) = generate_formula(Meta.parse(x))

"""
"""
function generate_formula(expression::Expr)
    original_expression = Meta.quot(copy(expression))
    StatsModels.sort_terms!(StatsModels.parse!(expression))
    left_hand_side = expression.args[2]
    right_hand_side = expression.args[3]
    formula_1 = StatsModels.Formula(
        original_expression,
        Meta.quot(expression),
        left_hand_side,
        right_hand_side,
        )
    terms_2 = StatsModels.Terms(formula_1)
    formula_3 = StatsModels.Formula(terms_2)
    terms_4 = StatsModels.Terms(formula_3)
    formula_5 = StatsModels.Formula(terms_4)
    terms_6 = StatsModels.Terms(formula_5)
    formula_7 = StatsModels.Formula(terms_6)
    return formula_7
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
    interaction_terms = generate_interaction_terms(
        independent_variables,
        interactions,
        )
    if intercept
        intercept_term = "1"
    else
        intercept_term = "0"
    end
    right_hand_side = intercept_term * "+" * join(interaction_terms, "+")
    left_hand_side = join(string.(dependent_variables), "+")
    formula_string = left_hand_side * "~" * right_hand_side
    formula_object = generate_formula(formula_string)
    return formula_object
end

"""
"""
function generate_interaction_terms(
        independent_variables::AbstractVector{<:Symbol},
        interactions::Integer,
        )
    if length(independent_variables) < 1
        error("length(independent_variables) must be >= 1")
    end
    if interactions < 1
        error("interactions must be >= 1")
    end
    if interactions > length(independent_variables)
        error("interactions must be <= the number of independent variable")
    end
    independent_variable_strings = string.(independent_variables)
    combinations = collect(
        Combinatorics.combinations(
            independent_variable_strings,
            interactions,
            )
        )
    interaction_terms = Vector{String}(undef, length(combinations))
    for k = 1:length(combinations)
        interaction_terms[k] = string(join(combinations[k], "*"))
    end
    return interaction_terms
end
