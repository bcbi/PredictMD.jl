import MLBase

function issquarematrix(
        m::AbstractMatrix,
        )
    return size(m, 1) == size(m, 2)
        # return true
end

function cohenkappa(
        contingencytable::AbstractMatrix,
        )
    if !issquarematrix(contingencytable)
        error("contingencytable must be a square matrix")
    end
    numclasses = size(contingencytable, 1)
    if numclasses < 2
        error("number of classes must be >= 2")
    end
    totalnumcases = sum(contingencytable)
    # p_o = "relative observed agreement among raters (identical to accuracy)"
    p_o = sum(diag(contingencytable))/totalnumcases
    # n_k1 = number of times rater 1 predicted class k
    # n_k2 = number of times rater 2 predicted class k
    # rater 1 = rows
    # rater 2 = columns
    n_k1 = [sum( contingencytable[k,:] ) for k = 1:numclasses]
    n_k2 = [sum( contingencytable[:,k] ) for k = 1:numclasses]
    # p_e = "hypothetical probability of chance agreement"
    p_e = sum(n_k1 .* n_k2)/(totalnumcases^2)
    kappa = (p_o - p_e)/(1 - p_e)
    return kappa
end

function _contingencytableforcohenkappa(
        y1::AbstractVector,
        y2::AbstractVector,
        )
    classes = sort(
        unique(
            vcat(
                y1,
                y2
                )
            );
        rev = false,
        )
    numclasses = length(classes)
    if numclasses < 2
        error("number of classes must be >= 2")
    end
    return contingencytable
end

function cohenkappa(
        y1::AbstractVector,
        y2::AbstractVector,
        )
    contingencytable = _contingencytableforcohenkappa(y1, y2)
    result = cohenkappa(contingencytable)
    return result
end

function _contingencytableforcohenkappa(
        rocnums::MLBase.ROCNums,
        )
    # we'll arbitrarily set rows = predicted, columns = true/gold
    contingencytable = [rocnums.tp rocnums.fp; rocnums.fn rocnums.tp]
    return contingencytable
end

function cohenkappa(
        rocnums::MLBase.ROCNums,
        )
    contingencytable = _contingencytableforcohenkappa(rocnums)
    result = cohenkappa(contingencytable)
    return result
end
