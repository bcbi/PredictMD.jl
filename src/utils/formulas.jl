import StatsModels

function makeformula(
        labelnames::T1,
        featurenames::T2;
        intercept::T3 = true,
        ) where
        T1 <: AbstractVector where
        T2 <: AbstractVector where
        T3 <: Bool
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
