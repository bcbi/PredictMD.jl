using StatsModels

function generate_formula(
    label_variables::AbstractVector{Symbol},
    feature_variables::AbstractVector{Symbol};
    intercept=true,
    )
    num_label_vars = length(label_variables)
    if num_label_vars==0
        error("label_variables must be non-empty")
    end
    return [
        generate_formula(
            label_variables[i],
            feature_variables;
            intercept = intercept,
            )
        for i=1:num_label_vars
        ]
end

function generate_formula(
    label_variable::Symbol,
    feature_variables::AbstractVector{Symbol};
    intercept=true,
    )
    if length(feature_variables)==0
        error("feature_variables must be non-empty")
    end
    if intercept
        intercept_term = "1"
    else
        intercept_term = "0"
    end
    lhs = label_variable
    rhs = parse(intercept_term * "+" * join(feature_variables, "+"))
    return StatsModels.Formula(lhs, rhs)
end
