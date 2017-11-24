function numtotal(rocnums::MLBase.ROCNums)
    @assert(rocnums.p == rocnums.tp + rocnums.fn)
    @assert(rocnums.n == rocnums.tn + rocnums.fp)
    return rocnums.p + rocnums.n
end

function accuracy_nanfixed(rocnums::MLBase.ROCNums)
    if numtotal(rocnums) == 0
        return 0.
    else
        return ( rocnums.tp + rocnums.tn )/( numtotal(rocnums) )
    end
end

function true_positive_rate_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.p == 0
        return 0.
    else
        return MLBase.true_positive_rate(rocnums)
    end
end

sensitivity_nanfixed(rocnums::MLBase.ROCNums) =
    true_positive_rate_nanfixed(rocnums)

function true_negative_rate_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.n == 0
        return 0.
    else
        return MLBase.true_negative_rate(rocnums)
    end
end

specificity_nanfixed(rocnums::MLBase.ROCNums) =
    true_negative_rate_nanfixed(rocnums)

function false_positive_rate_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.n == 0
        return 0.
    else
        return MLBase.false_positive_rate(rocnums)
    end
end

function false_negative_rate_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.p == 0
        return 0.
    else
        return MLBase.false_negative_rate(rocnums)
    end
end

function precision_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.tp + rocnums.fp == 0
        return 0.
    else
        return MLBase.precision(rocnums)
    end
end

recall_nanfixed(rocnums::MLBase.ROCNums) =
    true_positive_rate_nanfixed(rocnums)

function positive_predictive_value_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.tp + rocnums.fp == 0
        return 0.
    else
        return ( rocnums.tp )/( rocnums.tp + rocnums.fp )
    end
end

function negative_predictive_value_nanfixed(rocnums::MLBase.ROCNums)
    if rocnums.tn + rocnums.fn == 0
        return 0.
    else
        return ( rocnums.tn )/( rocnums.tn + rocnums.fn )
    end
end

function fbetascore(
        precision::Real,
        recall::Real,
        β::Real,
        )
    return (1+β^2)*(precision*recall)/((β^2*precision)+(recall))
end

function fbetascore(
        precisions_list::StatsBase.RealVector,
        recalls_list::StatsBase.RealVector,
        β::Real,
        )
    if length(precisions_list) != length(recalls_list)
        error("precisions_list and recalls_list must have the same length")
    end
    n = length(precisions_list)
    return [fbetascore(precisions_list[i], recalls_list[i], β) for i = 1:n]
end
