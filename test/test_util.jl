@test(AluthgeSinhaBase.odds_to_probability(1) == 0.5)
@test(AluthgeSinhaBase.odds_to_probability(2/3) == 0.4)
@test(AluthgeSinhaBase.odds_to_probability(10/5) == 2/3)
@test(AluthgeSinhaBase.odds_to_probability(1/99) == 1/100)

@test(AluthgeSinhaBase.probability_to_odds(0.8) ≈ 4)
@test(AluthgeSinhaBase.probability_to_odds(0.75) == 3)
@test(AluthgeSinhaBase.probability_to_odds(0.1) ≈ 1/9)
@test(AluthgeSinhaBase.probability_to_odds(0.2) == 1/4)

dict1 = Dict(
    "a" => 1,
    "b" => 2,
    "c" => 3,
    "d" => 4,
    "e" => 5,
    "f" => 6,
    )

@test(AluthgeSinhaBase.injective(dict1))
@test(AluthgeSinhaBase.onetoone(dict1))

dict2 = Dict(
    1 => "odd",
    2 => "even",
    3 => "odd",
    4 => "even",
    5 => "odd",
    6 => "even",
    )

@test(!AluthgeSinhaBase.injective(dict2))
@test(!AluthgeSinhaBase.onetoone(dict2))
