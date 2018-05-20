import DataFrames
import GLM
import StatsModels

mutable struct GLMModel <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    formula::T4 where T4 <: StatsModels.Formula
    family::T5 where T5 <: GLM.Distribution
    link::T6 where T6 <: GLM.Link

    # parameters (learned from data):
    underlyingglm::T7 where T7 <: Union{Void, StatsModels.DataFrameRegressionModel}

    function GLMModel(
            formula::StatsModels.Formula,
            family::GLM.Distribution,
            link::GLM.Link;
            name::AbstractString = "",
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            )
        underlyingglm = nothing
        result = new(
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
end

function get_history(
        x::GLMModel;
        saving::Bool = false,
	loading::Bool = false,
        )
    return nothing
end

function set_feature_contrasts!(
        x::GLMModel,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

function get_underlying(
        x::GLMModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingglm
    return result
end

function fit!(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        )
    labelsandfeatures_df = hcat(labels_df, features_df)
    info(string("INFO Starting to train GLM.jl model."))
    glm = try
        GLM.glm(
            estimator.formula,
            labelsandfeatures_df,
            estimator.family,
            estimator.link,
            )
    catch e
        warn(
            string(
                "WARN while training GLM.jl model, ignored error: ",
                e,
                )
            )
        nothing
    end
    # glm =
    info(string("INFO Finished training GLM.jl model."))
    estimator.underlyingglm = glm
    return estimator
end

function predict(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probabilitiesassoc = predict_proba(
            estimator,
            features_df,
            )
        predictionsvector = singlelabelprobabilitiestopredictions(
            probabilitiesassoc
            )
        result = DataFrames.DataFrame()
        labelname = estimator.formula.lhs
        result[labelname] = predictionsvector
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        if is_nothing(estimator.underlyingglm)
            glmpredictoutput = zeros(size(features_df,1))
        else
            glmpredictoutput = GLM.predict(
                estimator.underlyingglm,
                features_df,
                )
        end
        result = DataFrames.DataFrame()
        labelname = estimator.formula.lhs
        result[labelname] = glmpredictoutput
        return result
    else
        error("Could not figure out if model is classification or regression")
    end
end

function predict_proba(
        estimator::GLMModel,
        features_df::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        if is_nothing(estimator.underlyingglm,)
            glmpredictoutput = zeros(size(features_df, 1))
        else
            glmpredictoutput = GLM.predict(
                estimator.underlyingglm,
                features_df,
                )
        end
        result = Dict()
        result[1] = glmpredictoutput
        result[0] = 1 - glmpredictoutput
        result = fix_dict_type(result)
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("Could not figure out if model is classification or regression")
    end
end

function _singlelabelbinaryclassdataframelogisticclassifier_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    formula = generate_formula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        interactions = interactions,
        )
    dftransformer = ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = GLMModel(
        formula,
        GLM.Binomial(),
        GLM.LogitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predictlabelfixer = ImmutablePredictionsSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    predprobalabelfixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
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

function singlelabelbinaryclassdataframelogisticclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabelbinaryclassdataframelogisticclassifier_GLM(
            featurenames,
            singlelabelname,
            singlelabellevels;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

function _singlelabelbinaryclassdataframeprobitclassifier_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    formula = generate_formula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        interactions = interactions,
        )
    dftransformer = ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = GLMModel(
        formula,
        GLM.Binomial(),
        GLM.ProbitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predictlabelfixer = ImmutablePredictionsSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    predprobalabelfixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
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

function singlelabelbinaryclassdataframeprobitclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabelbinaryclassdataframeprobitclassifier_GLM(
            featurenames,
            singlelabelname,
            singlelabellevels;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

function _singlelabeldataframelinearregression_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    formula = generate_formula(
        [singlelabelname],
        featurenames;
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

function singlelabeldataframelinearregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        package::Symbol = :none,
        intercept::Bool = true,
        interactions::Integer = 1,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabeldataframelinearregression_GLM(
            featurenames,
            singlelabelname;
            intercept = intercept,
            interactions = interactions,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end
