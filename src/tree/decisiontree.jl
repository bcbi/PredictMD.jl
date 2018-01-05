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
            singlelabelname::Symbol;
            name::AbstractString = "",
            nsubfeatures::Integer = 2,
            ntrees::Integer = 20,
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            levels::AbstractVector = [],
            )
        hyperparameters = Dict()
        hyperparameters[:nsubfeatures] = nsubfeatures
        hyperparameters[:ntrees] = ntrees
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            singlelabelname,
            levels,
            hyperparameters,
            )
        return result
    end
end

function underlying(x::MutableDecisionTreeRandomForestEstimator)
    result = x.randomforest
    return result
end

function fit!(
        estimator::MutableDecisionTreeRandomForestEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    randomforest = DecisionTree.build_forest(
        labelsarray,
        featuresarray,
        estimator.hyperparameters[:nsubfeatures],
        estimator.hyperparameters[:ntrees],
        )
    estimator.underlyingrandomforest = randomforest
    return estimator
end

function predict(
        estimator::MutableDecisionTreeRandomForestEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        error("predict is not defined for classification models")
    elseif estimator.isregressionmodel
    else
        error("unable to predict")
    end
end

function predict_proba(
        estimator::MutableDecisionTreeRandomForestEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        predictedprobabilities = DecisionTree.apply_forest_proba(
            estimator.underlyingrandomforest,
            featuresarray,
            estimator.levels,
            )
        result = Dict()
        for i = 1:length(estimator.levels)
            result[estimator.levels[i]] = predictedprobabilities[:, i]
        end
        return result
    elseif estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("unable to predict_proba")
    end
end

function _singlelabelrandomforestclassifier_DecisionTree(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = ImmutableDataFrame2DecisionTreeTransformer(
        featurenames,
        dffeaturecontrasts,
        singlelabelname,
        singlelabellevels,
        )
    randomforestestimator = MutableDecisionTreeRandomForestEstimator(
        singlelabelname;
        name = name,
        nsubfeatures = nsubfeatures,
        ntrees = ntrees,
        isclassificationmodel = true,
        isregressionmodel = false,
        levels = singlelabellevels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            randomforestestimator,
            probapackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelrandomforestclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts;
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
            dffeaturecontrasts;
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
