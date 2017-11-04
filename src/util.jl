function odds_to_probability(odds)
    return odds/(1 + odds)
end

function probability_to_odds(probability)
    return probability/(1 - probability)
end
