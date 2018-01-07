import DecisionTree

mutable struct MutableDecisionTreejlRandomForestEstimator <:
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

    function MutableDecisionTreejlRandomForestEstimator(
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

function underlying(x::MutableDecisionTreejlRandomForestEstimator)
    result = x.randomforest
    return result
end

function fit!(
        estimator::MutableDecisionTreejlRandomForestEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    info(string("Starting to train DecisionTree random forest model."))
    randomforest = DecisionTree.build_forest(
        labelsarray,
        featuresarray,
        estimator.hyperparameters[:nsubfeatures],
        estimator.hyperparameters[:ntrees],
        )
    info(string("Finished training DecisionTree random forest model."))
    estimator.underlyingrandomforest = randomforest
    return estimator
end

function predict(
        estimator::MutableDecisionTreejlRandomForestEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = singlelabelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        output = DecisionTree.apply_forest(
            estimator.underlyingrandomforest,
            featuresarray,
            )
        return output
    else
        error("Could not figure out if model is classification or regression")
    end
end

function predict_proba(
        estimator::MutableDecisionTreejlRandomForestEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
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
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("Could not figure out if model is classification or regression")
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
    randomforestestimator = MutableDecisionTreejlRandomForestEstimator(
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
    if package == :DecisionTreejl
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

function _singlelabelrandomforestregression_DecisionTree(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = ImmutableDataFrame2DecisionTreeTransformer(
        featurenames,
        dffeaturecontrasts,
        singlelabelname,
        )
    randomforestestimator = MutableDecisionTreejlRandomForestEstimator(
        singlelabelname;
        name = name,
        nsubfeatures = nsubfeatures,
        ntrees = ntrees,
        isclassificationmodel = false,
        isregressionmodel = true,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            randomforestestimator,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelrandomforestregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    if package == :DecisionTreejl
        result = _singlelabelrandomforestregression_DecisionTree(
            featurenames,
            singlelabelname,
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

const randomforestregression = singlelabelrandomforestregression
