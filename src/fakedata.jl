using DataFrames
using StatsBase

function generatefaketabulardata(num_rows::Integer)
    return generatefaketabulardata(Base.GLOBAL_RNG, num_rows)
end

function generatefaketabulardata(rng::AbstractRNG, num_rows::Integer)
    dataframe = DataFrame()

    # dataframe[:catfeat1] = Vector{String}(num_rows)
    dataframe[:catfeat2] = Vector{String}(num_rows)
    dataframe[:catfeat3] = Vector{String}(num_rows)
    dataframe[:catfeat4] = Vector{String}(num_rows)
    dataframe[:intfeat1] = -99*ones(Int, num_rows)
    dataframe[:intfeat2] = -99*ones(Int, num_rows)
    dataframe[:floatfeat1] = -99*ones(Cfloat, num_rows)
    dataframe[:floatfeat2] = -99*ones(Cfloat, num_rows)
    for i = 1:num_rows
        # dataframe[i, :catfeat1] = StatsBase.sample(rng, ["A"])
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
            ( dataframe[i, :catfeat2] == "B" ? 2.0 : 0.5 ) .*
            ( dataframe[i, :catfeat3] == "D" ? 2.0 : 0.5 ) .*
            ( dataframe[i, :catfeat4] == "G" ? 2.0 : 0.5 ) .*
            ( dataframe[i, :intfeat1] == 4 ? 2.0 : 0.5 ) .*
            ( dataframe[i, :intfeat2] > 90 ? 2.0 : 0.5 ) .*
            ( dataframe[i, :floatfeat1] > 75.5 ? 2.0 : 0.5 ) .*
            ( dataframe[i, :floatfeat2] < -100 ? 2.0 : 0.5 )
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
