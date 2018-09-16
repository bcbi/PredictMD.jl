##### Beginning of file

import LinearAlgebra
import MLBase

"""
"""
is_square(m::AbstractMatrix) = size(m, 1) == size(m, 2)

"""
"""
function cohen_kappa(contingency_table::AbstractMatrix)
    if !is_square(contingency_table)
        error("contingency_table must be a square matrix")
    end
    numclasses = size(contingency_table, 1)
    if numclasses < 2
        error("number of classes must be >= 2")
    end
    totalnumcases = sum(contingency_table)
    # p_o = "relative observed agreement among raters (identical to accuracy)"
    p_o = sum(LinearAlgebra.diag(contingency_table))/totalnumcases
    # n_k1 = number of times rater 1 predicted class k
    # n_k2 = number of times rater 2 predicted class k
    # rater 1 = rows
    # rater 2 = columns
    n_k1 = [sum( contingency_table[k,:] ) for k = 1:numclasses]
    n_k2 = [sum( contingency_table[:,k] ) for k = 1:numclasses]
    # p_e = "hypothetical probability of chance agreement"
    p_e = sum(n_k1 .* n_k2)/(totalnumcases^2)
    kappa = (p_o - p_e)/(1 - p_e)
    return kappa
end

"""
"""
function compute_contingency_table(y1::AbstractVector, y2::AbstractVector)
    classes = sort(unique(vcat(y1, y2)); rev = false,)
    numclasses = length(classes)
    if numclasses < 2
        error("number of classes must be >= 2")
    end
    return contingency_table
end

"""
"""
function cohen_kappa(y1::AbstractVector, y2::AbstractVector)
    contingency_table = compute_contingency_table(y1, y2)
    result = cohen_kappa(contingency_table)
    return result
end

"""
"""
function compute_contingency_table(rocnums::MLBase.ROCNums)
    # we will arbitrarily set rows = predicted, columns = true/gold
    contingency_table = [rocnums.tp rocnums.fp; rocnums.fn rocnums.tp]
    return contingency_table
end

"""
"""
function cohen_kappa(rocnums::MLBase.ROCNums)
    contingency_table = compute_contingency_table(rocnums)
    result = cohen_kappa(contingency_table)
    return result
end

##### End of file
