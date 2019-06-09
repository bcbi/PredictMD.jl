##### Beginning of file

import DataFrames
import GLM
import StatsModels

function GLMModel(
        formula::StatsModels.Formula,
        family::GLM.Distribution,
        link::GLM.Link;
        name::AbstractString = "",
        isclassificationmodel::Bool = false,
        isregressionmodel::Bool = false,
        )
    underlyingglm = FitNotYetRunUnderlyingObject()
    result = GLMModel(
        name,
        isclassificationmodel,
        isregressionmodel,
        formula,
        family,
        link,
        underlyingglm,
        )
    return result
end

"""
"""
function get_history(
        x::GLMModel;
        saving::Bool = false,
	loading::Bool = false,
        )
    return nothing
end

"""
"""
function set_feature_contrasts!(
        x::GLMModel,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::GLMModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingglm
    return result
end

"""
"""
function parse_functions!(estimator::GLMModel)
    return nothing
end

"""
"""
function fit!(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        )
    labelsandfeatures_df = hcat(labels_df, features_df)
    @info(string("Starting to train GLM model."))
    glm = try
        GLM.glm(
            estimator.formula,
            labelsandfeatures_df,
            estimator.family,
            estimator.link,
            )
    catch e
        @warn(
            string(
                "while training GLM model, ignored error: ",
                e,
                )
            )
        FitFailedUnderlyingObject()
    end
    # glm =
    @info(string("Finished training GLM model."))
    estimator.underlyingglm = glm
    return estimator
end

"""
"""
function predict(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probabilitiesassoc = predict_proba(
            estimator,
            features_df,
            )
        predictionsvector = single_labelprobabilitiestopredictions(
            probabilitiesassoc
            )
        result = DataFrames.DataFrame()
        label_name = estimator.formula.lhs
        result[label_name] = predictionsvector
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        if isa(estimator.underlyingglm, AbstractNonExistentUnderlyingObject)
            glmpredictoutput = fill(Cfloat(0), size(features_df,1))
        else
            glmpredictoutput = GLM.predict(
                estimator.underlyingglm,
                features_df,
                )
        end
        result = DataFrames.DataFrame()
        label_name = estimator.formula.lhs
        result[label_name] = glmpredictoutput
        return result
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
end

"""
"""
function predict_proba(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        if isa(estimator.underlyingglm, AbstractNonExistentUnderlyingObject)
            glmpredictoutput = fill(Cfloat(0), size(features_df, 1))
        else
            glmpredictoutput = GLM.predict(
                estimator.underlyingglm,
                features_df,
                )
        end
        result = Dict()
        result[1] = glmpredictoutput
        result[0] = 1 .- glmpredictoutput
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
function singlelabelbinaryclassdataframelogisticclassifier_GLM(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    negative_class = single_label_levels[1]
    positive_class = single_label_levels[2]
    formula = generate_formula(
        [single_label_name],
        feature_names;
        intercept = intercept,
        interactions = interactions,
        )
    dftransformer =
        ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
            single_label_name,
            positive_class,
            )
    glmestimator = GLMModel(
        formula,
        GLM.Binomial(),
        GLM.LogitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predictlabelfixer =
        ImmutablePredictionsSingleLabelInt2StringTransformer(
            0,
            single_label_levels,
            )
    predprobalabelfixer =
        ImmutablePredictProbaSingleLabelInt2StringTransformer(
            0,
            single_label_levels,
            )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        single_label_name,
        )
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            glmestimator,
            predictlabelfixer,
            predprobalabelfixer,
            probapackager,
            ];
        name = name,
        )
    return finalpipeline
end

"""
"""
function singlelabelbinaryclassdataframelogisticclassifier(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLM
        result = singlelabelbinaryclassdataframelogisticclassifier_GLM(
            feature_names,
            single_label_name,
            single_label_levels;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

"""
"""
function singlelabelbinaryclassdataframeprobitclassifier_GLM(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    negative_class = single_label_levels[1]
    positive_class = single_label_levels[2]
    formula = generate_formula(
        [single_label_name],
        feature_names;
        intercept = intercept,
        interactions = interactions,
        )
    dftransformer =
        ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
            single_label_name,
            positive_class,
            )
    glmestimator = GLMModel(
        formula,
        GLM.Binomial(),
        GLM.ProbitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predictlabelfixer =
        ImmutablePredictionsSingleLabelInt2StringTransformer(
            0,
            single_label_levels,
            )
    predprobalabelfixer =
        ImmutablePredictProbaSingleLabelInt2StringTransformer(
            0,
            single_label_levels,
            )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        single_label_name,
        )
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            glmestimator,
            predictlabelfixer,
            predprobalabelfixer,
            probapackager,
            ];
        name = name,
        )
    return finalpipeline
end

"""
"""
function singlelabelbinaryclassdataframeprobitclassifier(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLM
        result = singlelabelbinaryclassdataframeprobitclassifier_GLM(
            feature_names,
            single_label_name,
            single_label_levels;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

"""
"""
function single_labeldataframelinearregression_GLM(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    formula = generate_formula(
        [single_label_name],
        feature_names;
        intercept = intercept,
        interactions = interactions,
        )
    glmestimator = GLMModel(
        formula,
        GLM.Normal(),
        GLM.IdentityLink();
        isclassificationmodel = false,
        isregressionmodel = true,
        )
    finalpipeline = SimplePipeline(
        Fittable[
            glmestimator,
            ];
        name = name,
        )
    return finalpipeline
end

"""
"""
function single_labeldataframelinearregression(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLM
        result = single_labeldataframelinearregression_GLM(
            feature_names,
            single_label_name;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

##### End of file
