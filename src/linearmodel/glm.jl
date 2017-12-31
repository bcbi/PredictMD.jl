import DataFrames
import GLM
import StatsModels

abstract type AbstractASBGLMjlGeneralizedLinearModelClassifier <:
        AbstractClassifier
end

abstract type AbstractASBGLMjlGeneralizedLinearModelRegression <:
        AbstractRegression
end

mutable struct ASBGLMjlGeneralizedLinearModelClassifier <:
        AbstractASBGLMjlGeneralizedLinearModelClassifier
    name::T1 where T1 <: AbstractString

    # hyperparameters (not learned from data):
    formula::T2 where T2 <: StatsModels.Formula
    family::T3 where T3 <: GLM.Distribution
    link::T4 where T4 <: GLM.Link

    # parameters (learned from data):
    glm::T5 where T5

    function ASBGLMjlGeneralizedLinearModelClassifier(
            formula::StatsModels.Formula,
            family::GLM.Distribution,
            link::GLM.Link;
            name::AbstractString = "",
            )
        return new(name, formula, family, link)
    end
end

function underlying(x::AbstractASBGLMjlGeneralizedLinearModelClassifier)
    result = x.glm
    return result
end

function fit!(
        estimator::AbstractASBGLMjlGeneralizedLinearModelClassifier,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        )
    labelsandfeaturesdf = hcat(labelsdf, featuresdf)
    glm = GLM.glm(
        estimator.formula,
        labelsandfeaturesdf,
        estimator.family,
        estimator.link,
        )
    estimator.glm = glm
    return estimator
end

function predict_proba(
        estimator::AbstractASBGLMjlGeneralizedLinearModelClassifier,
        featuresdf::DataFrames.AbstractDataFrame,
        )
    glmpredictoutput = GLM.predict(
        estimator.glm,
        featuresdf,
        )
    result = Dict()
    result[1] = glmpredictoutput
    result[0] = 1 - glmpredictoutput
    return result
end

function fit!(
        estimator::AbstractASBGLMjlGeneralizedLinearModelRegression,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        )
    labelsandfeaturesdf = hcat(labelsdf, featuresdf)
    glm = GLM.glm(
        estimator.formula,
        labelsandfeaturesdf,
        estimator.family,
        estimator.link,
        )
    estimator.glm = glm
    return estimator
end

function _singlelabelbinarylogisticclassifier_GLMjl(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        intercept::Bool = true,
        name::AbstractString = "",
        )
    if length(singlelabellevels) !== length(unique(singlelabellevels))
        error("singlelabellevels has duplicates")
    end
    if length(singlelabellevels) !== 2
        error("length(singlelabellevels) !== 2")
    end
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    formula = makeformula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        )
    dftransformer = DataFrame2GLMjlTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = ASBGLMjlGeneralizedLinearModelClassifier(
        formula,
        GLM.Binomial(),
        GLM.LogitLink(),
        )
    predprobafixer = PredictProbaSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    probapackager = PackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = SimplePipeline(
        [
            dftransformer,
            glmestimator,
            predprobafixer,
            probapackager,
            ];
        name = name,
        underlyingobjectindex = 2,
        )
    return finalpipeline
end

function singlelabelbinarylogisticclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabelbinarylogisticclassifier_GLMjl(
            featurenames,
            singlelabelname,
            singlelabellevels;
            intercept = intercept,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const binarylogisticclassifier = singlelabelbinarylogisticclassifier
