import DataFrames

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

function findnearest(A::AbstractArray, x)
    exact_matches = A.==x
    if sum(exact_matches) > 0
        return find(exact_matches)
    else
        distances = abs.(A .- x)
        minimumdistance = minimum(distances)
        nearest_matches = distances.==minimumdistance
        @assert( sum(nearest_matches) > 0 )
        return find(nearest_matches)
    end
end

ensurevector(x::AbstractVector) = x

function ensurevector(x::AbstractMatrix)
    if size(x,2) == 1
        return x[:, 1]
    else
        error("x does not have exactly one column")
    end
end

function plural(word::AbstractString, n::Integer)
    suffix = endswith(word, "s") ? "es" : "s"
    if n > 1 || n == 0
        return word*suffix
    elseif n == 1
        return word
    else
        error("n must be a non-negative integer")
    end
end

function make_string!(df::DataFrames.AbstractDataFrame,symb_list::AbstractVector{T}) where T <: Symbol
  num_symbs = length(symb_list)
  num_symbs == 0 && error("Symb_list should not be empty")
  for i=1:num_symbs
    col = df[symb_list[i]]
    DataFrames.delete!(df,symb_list[i])
    new_col = string.(col)
    df[symb_list[i]] = new_col
  end
  return df
end
