import DataFrames
import GLM
import StatsModels


mutable struct MutableGLMEstimator <: AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    formula::T4 where T4 <: StatsModels.Formula
    family::T5 where T5 <: GLM.Distribution
    link::T6 where T6 <: GLM.Link

    # parameters (learned from data):
    underlyingglm::T where T

    function MutableGLMEstimator(
            formula::StatsModels.Formula,
            family::GLM.Distribution,
            link::GLM.Link;
            name::AbstractString = "",
            )
        result = new(
            )
        return result
    end
end

function underlying(x::AbstractASBGLMGeneralizedLinearModelClassifier)
    result = x.glm
    return result
end

function fit!(
        estimator::AbstractASBGLMGeneralizedLinearModelClassifier,
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
        estimator::AbstractASBGLMGeneralizedLinearModelClassifier,
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
        estimator::AbstractASBGLMGeneralizedLinearModelRegression,
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

function _singlelabelbinarylogisticclassifier_GLM(
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
    dftransformer = DataFrame2GLMTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = ASBGLMGeneralizedLinearModelClassifier(
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
    if package == :GLM
        result =_singlelabelbinarylogisticclassifier_GLM(
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
