import DecisionTree

mutable struct MutableDecisionTreeRandomForestEstimator <:
        AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    singlelabelname::T4 where T4 <: Symbol
    levels::T5 where T5 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T6 where T6 <: Associative

    # parameters (learned from data):
    underlyingrandomforest::T7 where T7

    function MutableDecisionTreeRandomForestEstimator(
            singlelabelname::Symbol,
            levels::AbstractVector;
            name::AbstractString = "",
            nsubfeatures::Integer = 2,
            ntrees::Integer = 20,
            )
        result = new(
            )
        return result
    end
end

function underlying(x::AbstractASBDecisionTreeRandomForestClassifier)
    result = x.randomforest
    return result
end

function fit!(
        estimator::AbstractASBDecisionTreeRandomForestClassifier,
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
        estimator::AbstractASBDecisionTreeRandomForestClassifier,
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

function _singlelabelrandomforestclassifier_DecisionTree(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = DataFrame2DecisionTreeTransformer(
        featurenames,
        singlelabelname,
        singlelabellevels,
        df,
        )
    randomforestestimator = ASBDecisionTreeRandomForestClassifier(
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
    if package == :DecisionTree
        result = _singlelabelrandomforestclassifier_DecisionTree(
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
