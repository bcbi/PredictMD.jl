function odds_to_probability(odds)
    return odds/(1 + odds)
end

function probability_to_odds(probability)
    return probability/(1 - probability)
end

onetoone(a::Associative) = injective(a)

function injective(a::Associative)
    all_values = values(a)
    unique_values = unique(all_values)
    return length(all_values)==length(unique_values)
end

function inverse(a::Associative)
    if !injective(a)
        error("Input is not injective (one-to-one.)")
    end
    original_keys = collect(keys(a))
    original_values = collect(values(a))
    result = Dict{eltype(original_values), eltype(original_keys)}()
    num_values = length(original_values)
    for i = 1:num_values
        v = original_values[i]
        k = original_keys[i]
        result[v] = k
    end
    return result
end

function binaryproba_onecoltotwocols(
        v::AbstractVector{T} where T <: Real
        )
    anyentryisnegative = any(v .< 0)
    if anyentryisnegative
        error("All entries of v must be non-negative.")
    end
    anyentryisgreaterthanone = any(v .> 1)
    if anyentryisgreaterthanone
        error("All entries of v must be <=1")
    end
    return hcat(1-v, v)
end

function binaryproba_twocolstoonecol(
        m::AbstractMatrix{T} where T <: Real
        )
    num_cols = size(m,2)
    if num_cols != 2
        error("m must have exactly two columns")
    end
    anyentryisnegative = any(m .< 0)
    if anyentryisnegative
        error("All entries of m must be >=0")
    end
    anyentryisgreaterthanone = any(m .> 1)
    if anyentryisgreaterthanone
        error("All entries of m must be <=1")
    end
    allrowssumtoone = all(sum(m,2) .≈ 1)
    if !allrowssumtoone
        error("Each row of m must sum to 1.")
    end
    return m[:, 2]
end

function calculate_smote_pct_under(
        pct_over::Real,
        minority_to_majority_ratio::Real = 1,
        )
    return 100*minority_to_majority_ratio*(100+pct_over)/pct_over
end

function fbetascore(precision::Real, recall::Real, β::Real)
    return (1+β^2)*(precision*recall)/((β^2*precision)+(recall))
end

function fbetascore(rocnums::MLBase.ROCNums, β::Real)
    precision = MLBase.precision(rocnums)
    recall = MLBase.recall(rocnums)
    return fbetascore(precision, recall, β)
end

function numtotal(rocnums::MLBase.ROCNums)
    @assert(
        (rocnums.tp + rocnums.fn) == (rocnums.p)
        )
    @assert(
        (rocnums.tn + rocnums.fp) == (rocnums.n)
        )
    return rocnums.p + rocnums.n
end

function accuracy(rocnums::MLBase.ROCNums)
    return ( rocnums.tp + rocnums.tn )/( numtotal(rocnums) )
end

ppv(rocnums::MLBase.ROCNums) = positivepredictivevalue(rocnums)
function positivepredictivevalue(rocnums::MLBase.ROCNums)
    return (rocnums.tp)/(rocnums.tp + rocnums.fp)
end

npv(rocnums::MLBase.ROCNums) = negativepredictivevalue(rocnums)
function negativepredictivevalue(rocnums::MLBase.ROCNums)
    return (rocnums.tn)/(rocnums.tn + rocnums.fn)
end

function replacenan!(A::AbstractArray, newvalue)
    A[isnan.(A)] = newvalue
    return A
end
