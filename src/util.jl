function odds_to_probability(odds)
    return odds/(1 + odds)
end

function probability_to_odds(probability)
    return probability/(1 - probability)
end

onetoone(a::Associative) = injective(a)

function injective(a::T) where T<:Associative
    all_values = values(a)
    unique_values = unique(all_values)
    return length(all_values)==length(unique_values)
end
