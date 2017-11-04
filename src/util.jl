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
    for v = original_values
        k = original_keys[original_values.==v][1]
        result[v] = k
    end
    return result
end
