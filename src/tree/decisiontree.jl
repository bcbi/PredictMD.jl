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

function setfeaturecontrasts!(
        x::MutableDecisionTreejlRandomForestEstimator,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function underlying(x::MutableDecisionTreejlRandomForestEstimator)
    return nothing
end

function getunderlying(
        x::MutableDecisionTreejlRandomForestEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingrandomforest
    return result
end

function setunderlying!(
        x::MutableDecisionTreejlRandomForestEstimator,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    x.underlyingrandomforest = object
    return nothing
end

function gethistory(
        x::MutableDecisionTreejlRandomForestEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::MutableDecisionTreejlRandomForestEstimator,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function fit!(
        estimator::MutableDecisionTreejlRandomForestEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    info(string("Starting to train DecisionTree.jl model."))
    randomforest = DecisionTree.build_forest(
        labelsarray,
        featuresarray,
        estimator.hyperparameters[:nsubfeatures],
        estimator.hyperparameters[:ntrees],
        )
    info(string("Finished training DecisionTree.jl model."))
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

function _singlelabelmulticlassdataframerandomforestclassifier_DecisionTree(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = MutableDataFrame2DecisionTreeTransformer(
        featurenames,
        singlelabelname;
        levels = singlelabellevels,
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
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            randomforestestimator,
            probapackager,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelmulticlassdataframerandomforestclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    if package == :DecisionTreejl
        result = _singlelabelmulticlassdataframerandomforestclassifier_DecisionTree(
            featurenames,
            singlelabelname,
            singlelabellevels;
            name = name,
            nsubfeatures = nsubfeatures,
            ntrees = ntrees,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

function _singlelabeldataframerandomforestregression_DecisionTree(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    dftransformer = MutableDataFrame2DecisionTreeTransformer(
        featurenames,
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

function singlelabeldataframerandomforestregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        )
    if package == :DecisionTreejl
        result = _singlelabeldataframerandomforestregression_DecisionTree(
            featurenames,
            singlelabelname;
            name = name,
            nsubfeatures = nsubfeatures,
            ntrees = ntrees,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end
