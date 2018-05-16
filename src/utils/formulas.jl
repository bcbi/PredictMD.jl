import StatsModels

function generate_formula(
        singlelabelname::Symbol,
        featurenames::AbstractVector;
        intercept::Bool = true,
        )
    result = generate_formula(
        [singlelabelname],
        featurenames;
        intercept = intercept;
        )
    return result
end

function generate_formula(
        labelnames::AbstractVector,
        featurenames::AbstractVector;
        intercept::Bool = true,
        )
    if length(labelnames) == 0
        error("length(labelnames) == 0")
    end
    if length(featurenames) == 0
        error("length(featurenames) == 0")
    end
    labelnames_asstrings = [string(x) for x in labelnames]
    featurenames_asstrings = [string(x) for x in featurenames]
    lhs_string = join(labelnames_asstrings, "+")
    interceptterm = intercept ? "1" : "0"
    rhs_string = interceptterm * "+" * join(featurenames_asstrings, "+")
    lhs_expr = parse(lhs_string)
    rhs_expr = parse(rhs_string)
    result = StatsModels.Formula(lhs_expr, rhs_expr)
    return result
end
