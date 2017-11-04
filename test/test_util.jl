@test(AluthgeSinhaBase.odds_to_probability(1) == 0.5)
@test(AluthgeSinhaBase.odds_to_probability(2/3) == 0.4)
@test(AluthgeSinhaBase.odds_to_probability(10/5) == 2/3)
@test(AluthgeSinhaBase.odds_to_probability(1/99) == 1/100)

@test(AluthgeSinhaBase.probability_to_odds(0.8) ≈ 4)
@test(AluthgeSinhaBase.probability_to_odds(0.75) == 3)
@test(AluthgeSinhaBase.probability_to_odds(0.1) ≈ 1/9)
@test(AluthgeSinhaBase.probability_to_odds(0.2) == 1/4)
