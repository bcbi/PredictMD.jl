using DataFrames
using StatsBase

function generatefaketabulardata1(num_rows::Integer)
    return generatefaketabulardata1(Base.GLOBAL_RNG, num_rows)
end

function generatefaketabulardata1(rng::AbstractRNG, num_rows::Integer)
    dataframe = DataFrame()

    dataframe[:catfeat1] = Vector{String}(num_rows)
    dataframe[:catfeat2] = Vector{String}(num_rows)
    dataframe[:catfeat3] = Vector{String}(num_rows)
    dataframe[:catfeat4] = Vector{String}(num_rows)
    dataframe[:intfeat1] = -99*ones(Int, num_rows)
    dataframe[:intfeat2] = -99*ones(Int, num_rows)
    dataframe[:floatfeat1] = -99*ones(Cfloat, num_rows)
    dataframe[:floatfeat2] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        dataframe[i, :catfeat1] = StatsBase.sample(rng, ["A"])
        dataframe[i, :catfeat2] = StatsBase.sample(rng, ["B", "C"])
        dataframe[i, :catfeat3] = StatsBase.sample(rng, ["D", "E", "F"])
        dataframe[i, :catfeat4] = StatsBase.sample(rng, ["G", "H", "I", "J"])
        dataframe[i, :intfeat1] = rand(rng, Int.(1:5))
        dataframe[i, :intfeat2] = rand(rng, Int.(1:100))
        dataframe[i, :floatfeat1] = rand(rng, Cfloat)*10
        dataframe[i, :floatfeat2] = randn(rng, Cfloat)*10
    end

    dataframe[:oddsofbeingclassone] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        dataframe[i, :oddsofbeingclassone] =
            ( dataframe[i, :catfeat2] == "B" ? 2.0 : 0.8 ) .*
            ( dataframe[i, :catfeat3] == "D" ? 2.0 : 0.8 ) .*
            ( dataframe[i, :catfeat4] == "G" ? 2.0 : 0.8 ) .*
            ( dataframe[i, :intfeat1] == 4 ? 2.0 : 0.8 ) .*
            ( dataframe[i, :intfeat2] > 90 ? 2.0 : 0.8 ) .*
            ( dataframe[i, :floatfeat1] > 75.5 ? 2.0 : 0.8 ) .*
            ( dataframe[i, :floatfeat2] < -100 ? 2.0 : 0.8 )
    end

    dataframe[:probabilityofbeingclassone] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        dataframe[i, :probabilityofbeingclassone] =
            odds_to_probability(dataframe[i,:oddsofbeingclassone])
    end

    dataframe[:mylabel1] = Vector{String}(num_rows)
    for i = 1:num_rows
        proba_classone = dataframe[i, :probabilityofbeingclassone]
        proba_classzero = 1 - proba_classone
        pweightvector = ProbabilityWeights([proba_classzero, proba_classone])
        dataframe[i, :mylabel1] = StatsBase.sample(
            ["classzero", "classone"],
            pweightvector,
            )
    end

    dataframe[:mylabel2] = Vector{String}(num_rows)
    for i = 1:num_rows
        dataframe[i, :mylabel2] = StatsBase.sample(
            ["tails", "head"]
            )
    end

    dataframe[:mylabel3] = Vector{String}(num_rows)
    for i = 1:num_rows
        dataframe[i, :mylabel3] = StatsBase.sample(
            ["one", "two", "three", "four", "five", "six"]
            )
    end

    label_variables = [
        :mylabel1,
        :mylabel2,
        :mylabel3,
        ]
    feature_variables = [
        # :catfeat1,
        :catfeat2,
        :catfeat3,
        :catfeat4,
        :intfeat1,
        :intfeat2,
        :floatfeat1,
        :floatfeat2,
        ]

    return dataframe, label_variables, feature_variables
end

##############################################################################

function generatefaketabulardata2(num_rows::Integer)
    return generatefaketabulardata2(Base.GLOBAL_RNG, num_rows)
end

function generatefaketabulardata2(rng::AbstractRNG, num_rows::Integer)
    dataframe = DataFrame()

    dataframe[:x] = Vector{String}(num_rows)
    for i = 1:num_rows
        dataframe[i, :x] = StatsBase.sample(rng, ["heads", "tails"])
    end

    dataframe[:y] = -99*ones(Int, num_rows)
    pweightvector_heads = StatsBase.ProbabilityWeights([0.10, 0.90])
    pweightvector_tails = StatsBase.ProbabilityWeights([0.89, 0.11])
    for i = 1:num_rows
        if dataframe[i, :x] == "heads"
            dataframe[i, :y] = StatsBase.sample(
                rng,
                [0, 1],
                pweightvector_heads,
                )
        else
            dataframe[i, :y] = StatsBase.sample(
                rng,
                [0, 1],
                pweightvector_tails,
                )
        end
    end

    label_variables = [
        :y,
        ]
    feature_variables = [
        :x,
        ]

    return dataframe, label_variables, feature_variables
end

##############################################################################

function generatefaketabulardata3(num_rows::Integer)
    return generatefaketabulardata3(Base.GLOBAL_RNG, num_rows)
end

function generatefaketabulardata3(rng::AbstractRNG, num_rows::Integer)
    dataframe = DataFrame()

    dataframe[:favoritecolor] = Array{String,1}(num_rows)
    for i = 1:num_rows
        dataframe[i, :favoritecolor] = StatsBase.sample(
            rng,
            ["red", "yellow", "blue"],
            )
    end
    dataframe[:favoriteicecream] = Array{String,1}(num_rows)
    for i = 1:num_rows
        dataframe[i, :favoriteicecream] = StatsBase.sample(
            rng,
            ["chocolate", "vanilla"],
            )
    end

    dataframe[:numberofbeaniebabies] = -99*ones(Int, num_rows)
    for i = 1:num_rows
        dataframe[i, :numberofbeaniebabies] = StatsBase.sample(
            rng,
            0:100,
            )
    end
    dataframe[:oddsofdying] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        dataframe[i, :oddsofdying] =
            ( dataframe[i,:favoritecolor]=="red" ? 10 : 0.10 ) *
            ( dataframe[i,:favoriteicecream]=="chocolate" ? 2 : 0.50 ) *
            ( dataframe[i,:numberofbeaniebabies]>90 ? 5 : 0.20 )
    end


    dataframe[:probaofdying] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        dataframe[i, :probaofdying] = odds_to_probability(
            dataframe[i, :oddsofdying],
            )
    end

    dataframe[:deathoutcome] = Array{String, 1}(num_rows)
    for i = 1:num_rows
        i_probaofdying = dataframe[i, :oddsofdying]
        i_probavector = [1-i_probaofdying, i_probaofdying]
        i_pweightvector = StatsBase.ProbabilityWeights(i_probavector)
        dataframe[i, :deathoutcome] = StatsBase.sample(
            ["Lived", "Died"],
            i_pweightvector,
            )
    end

    label_variables = [
        :deathoutcome,
        ]
    feature_variables = [
        :favoritecolor,
        :favoriteicecream,
        :numberofbeaniebabies,
        ]

    return dataframe, label_variables, feature_variables
end
