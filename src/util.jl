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
