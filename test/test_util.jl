using DataFrames

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

dict1_inverse = AluthgeSinhaBase.inverse(dict1)
@test(
    dict1_inverse == Dict(
        1 => "a",
        2 => "b",
        3 => "c",
        4 => "d",
        5 => "e",
        6 => "f",
        )
    )

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

@test_throws(ErrorException, AluthgeSinhaBase.inverse(dict2))

a = [
    0,
    .1,
    .2,
    .3,
    .4,
    .5,
    .6,
    .7,
    .8,
    .9,
    1,
    ]
a_twocols = AluthgeSinhaBase.binaryproba_onecoltotwocols(a)
a_twocols_correctanswer = [
    1 0;
    .9 .1;
    .8 .2;
    .7 .3;
    .6 .4;
    .5 .5;
    .4 .6;
    .3 .7;
    .2 .8;
    .1 .9;
    0 1;
    ]
@test(all(a_twocols.≈a_twocols_correctanswer))

b = [
    .95 .05;
    .85 .15;
    .75 .25;
    .65 .35;
    .55 .45;
    .45 .55;
    .35 .65;
    .25 .75;
    .15 .85;
    .05 .95;
    ]
b_onecol = AluthgeSinhaBase.binaryproba_twocolstoonecol(b)
b_onecol_correct_answer = [
    .05,
    .15,
    .25,
    .35,
    .45,
    .55,
    .65,
    .75,
    .85,
    .95,
    ]
@test(all(b_onecol.≈b_onecol_correct_answer))

@test(AluthgeSinhaBase.calculate_smote_pct_under(100) == 200)

@test(AluthgeSinhaBase.calculate_smote_pct_under(200) == 150)

@test(AluthgeSinhaBase.calculate_smote_pct_under(400) == 125)

@test(AluthgeSinhaBase.calculate_smote_pct_under(1000) == 110)

@test(AluthgeSinhaBase.calculate_smote_pct_under(10000) == 101)

df = DataFrame()
df[:Ishan] = [4,2,0]
df[:Dilum] = [1,6,6]

AluthgeSinhaBase.make_string!(df,[:Ishan,:Dilum])
@test(df[:Ishan] == ["4","2","0"] && df[:Dilum] == ["1","6","6"])

println(AluthgeSinhaBase.timestamp())
@test(typeof(AluthgeSinhaBase.timestamp()) <: AbstractString)
