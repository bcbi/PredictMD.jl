##### Beginning of file

import DecisionTree

function DecisionTreeModel(
        single_label_name::Symbol;
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
    hyperparameters = fix_type(hyperparameters)
    underlyingrandomforest = FitNotYetRunUnderlyingObject()
    result = DecisionTreeModel(
        name,
        isclassificationmodel,
        isregressionmodel,
        single_label_name,
        levels,
        hyperparameters,
        underlyingrandomforest,
        )
    return result
end

"""
"""
function set_feature_contrasts!(
        x::DecisionTreeModel,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function underlying(x::DecisionTreeModel)
    return nothing
end

"""
"""
function get_underlying(
        x::DecisionTreeModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingrandomforest
    return result
end

"""
"""
function get_history(
        x::DecisionTreeModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(estimator::DecisionTreeModel)
    return nothing
end

"""
"""
function fit!(
        estimator::DecisionTreeModel,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    @info(string("Starting to train DecisionTree model."))
    randomforest = try
        DecisionTree.build_forest(
            labelsarray,
            featuresarray,
            estimator.hyperparameters[:nsubfeatures],
            estimator.hyperparameters[:ntrees],
            )
    catch e
        @warn(
            string(
                "While training DecisionTree model, ignored error: ",
                e,
                )
            )
        FitFailedUnderlyingObject()
    end
    @info(string("Finished training DecisionTree model."))
    estimator.underlyingrandomforest = randomforest
    return estimator
end

"""
"""
function predict(
        estimator::DecisionTreeModel,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = single_labelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        if is_nothing(estimator.underlyingrandomforest)
            predicted_values = fill(Cfloat(0), size(featuresarray,1))
        else
            predicted_values = DecisionTree.apply_forest(
                estimator.underlyingrandomforest,
                featuresarray,
                )
        end
        return predicted_values
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
end

"""
"""
function predict_proba(
        estimator::DecisionTreeModel,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        if is_nothing(estimator.underlyingrandomforest)
            predictedprobabilities = fill(
                Cfloat(0),
                size(featuresarray, 1),
                length(estimator.levels),
                )
            predictedprobabilities[:, 1] = 1
        else
            predictedprobabilities = DecisionTree.apply_forest_proba(
                estimator.underlyingrandomforest,
                featuresarray,
                estimator.levels,
                )
        end
        result = Dict()
        for i = 1:length(estimator.levels)
            result[estimator.levels[i]] = predictedprobabilities[:, i]
        end
        result = fix_type(result)
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
end

"""
"""
function single_labelmulticlassdfrandomforestclassifier_DecisionTree(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    dftransformer = MutableDataFrame2DecisionTreeTransformer(
        feature_names,
        single_label_name;
        levels = single_label_levels,
        )
    randomforestestimator = DecisionTreeModel(
        single_label_name;
        name = name,
        nsubfeatures = nsubfeatures,
        ntrees = ntrees,
        isclassificationmodel = true,
        isregressionmodel = false,
        levels = single_label_levels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        single_label_name,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        single_label_name,
        )
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            randomforestestimator,
            probapackager,
            predpackager,
            ];
        name = name,
        )
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
function single_labelmulticlassdataframerandomforestclassifier(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    if package == :DecisionTree
        result =
            single_labelmulticlassdfrandomforestclassifier_DecisionTree(
                feature_names,
                single_label_name,
                single_label_levels;
                name = name,
                nsubfeatures = nsubfeatures,
                ntrees = ntrees,
                feature_contrasts = feature_contrasts
                )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

"""
"""
function single_labeldataframerandomforestregression_DecisionTree(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        name::AbstractString = "",
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    dftransformer = MutableDataFrame2DecisionTreeTransformer(
        feature_names,
        single_label_name,
        )
    randomforestestimator = DecisionTreeModel(
        single_label_name;
        name = name,
        nsubfeatures = nsubfeatures,
        ntrees = ntrees,
        isclassificationmodel = false,
        isregressionmodel = true,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        single_label_name,
        )
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            randomforestestimator,
            predpackager,
            ];
        name = name,
        )
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
function single_labeldataframerandomforestregression(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        name::AbstractString = "",
        package::Symbol = :none,
        nsubfeatures::Integer = 2,
        ntrees::Integer = 10,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    if package == :DecisionTree
        result = single_labeldataframerandomforestregression_DecisionTree(
            feature_names,
            single_label_name;
            name = name,
            nsubfeatures = nsubfeatures,
            ntrees = ntrees,
            feature_contrasts = feature_contrasts
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

##### End of file
