import DecisionTree

abstract type AbstractASBDecisionTreejlRandomForestClassifier <:
        AbstractClassifier
end

abstract type AbstractASBDecisionTreejlRandomForestRegression <:
        AbstractRegression
end

mutable struct ASBDecisionTreejlRandomForestClassifier <:
        AbstractASBDecisionTreejlRandomForestClassifier
    name::T1 where T1 <: AbstractString
    singlelabelname::T2 where T2 <: Symbol
    levels::T3 where T3 <: AbstractVector
    # hyperparameters (not learned from data):
    nsubfeatures::T4 where T4 <: Integer
    ntrees::T5 where T5 <: Integer
    # parameters (learned from data):
    randomforest::T6 where T6

    function ASBDecisionTreejlRandomForestClassifier(
            singlelabelname::Symbol,
            levels::AbstractVector;
            name::AbstractString = "",
            nsubfeatures::Integer = 2,
            ntrees::Integer = 10
            )
        return new(name, singlelabelname, levels, nsubfeatures, ntrees)
    end
end

function underlying(x::AbstractASBDecisionTreejlRandomForestClassifier)
    result = x.randomforest
    return result
end

function fit!(
        estimator::AbstractASBDecisionTreejlRandomForestClassifier,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    nsubfeatures = estimator.nsubfeatures
    ntrees = estimator.ntrees
    randomforest = DecisionTree.build_forest(
        labelsarray,
        featuresarray,
        nsubfeatures,
        ntrees
        )
    estimator.randomforest = randomforest
    return estimator
end

function predict_proba(
        estimator::AbstractASBDecisionTreejlRandomForestClassifier,
        featuresarray::AbstractArray,
        )
    predictedprobabilities = DecisionTree.apply_forest_proba(
        estimator.randomforest,
        featuresarray,
        estimator.levels,
        )
    result = Dict()
    for i = 1:length(estimator.levels)
        result[estimator.levels[i]] = predictedprobabilities[:, i]
    end
    return result
end

function _singlelabelrandomforestclassifier_DecisionTreejl(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = DataFrame2DecisionTreejlTransformer(
        featurenames,
        singlelabelname,
        singlelabellevels,
        df,
        )
    randomforestestimator = ASBDecisionTreejlRandomForestClassifier(
        singlelabelname,
        singlelabellevels;
        name = name,
        nsubfeatures = nsubfeatures,
        ntrees = ntrees,
        )
    probapackager = PackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = SimplePipeline(
        [
            dftransformer,
            randomforestestimator,
            probapackager,
            ];
        name = name,
        underlyingobjectindex = 2,
        )
    return finalpipeline
end

function singlelabelrandomforestclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    if package == :DecisionTreejl
        result = _singlelabelrandomforestclassifier_DecisionTreejl(
            featurenames,
            singlelabelname,
            singlelabellevels,
            df;
            name = name,
            nsubfeatures = nsubfeatures,
            ntrees = ntrees,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const randomforestclassifier = singlelabelrandomforestclassifier
