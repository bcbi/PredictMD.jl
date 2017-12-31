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

mutable struct ASBGLMjlGeneralizedLinearModelRegression <:
        AbstractASBGLMjlGeneralizedLinearModelRegression
#     # hyperparameters (not learned from data):
#     formula::T1 where T1 <: StatsModels.Formula
#     family::T2 where T2 <: GLM.Distribution
#     link::T3 where T3 <: GLM.Link
#
#     # parameters (learned from data):
#     glm::T4 where T4
#
#     function ASBGLMjlGeneralizedLinearModelRegression(
#             formula::StatsModels.Formula,
#             family::GLM.Distribution,
#             link::GLM.Link,
#             )
#         return new(formula, family, link)
#     end
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
    labelresult = Dict()
    labelresult[1] = glmpredictoutput
    labelresult[0] = 1 - glmpredictoutput
    label = estimator.formula.lhs
    @assert(typeof(label) <: Symbol)
    allresults = Dict()
    allresults[label] = labelresult
    return allresults
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
        singlelabelpositiveclass::AbstractString;
        intercept::Bool = true,
        name::AbstractString = "",
        )
    formula = makeformula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        )
    dftransformer = DataFrame2GLMjlTransformer(
        singlelabelname,
        singlelabelpositiveclass,
        )
    glmestimator = ASBGLMjlGeneralizedLinearModelClassifier(
        formula,
        GLM.Binomial(),
        GLM.LogitLink(),
        )
    finalobjectsvector = [dftransformer, glmestimator]
    finalpipeline = SimplePipeline(finalobjectsvector; name = name)
    return finalpipeline
end

function singlelabelbinarylogisticclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabelpositiveclass::AbstractString;
        package::Symbol = :none,
        intercept::Bool = true,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabelbinarylogisticclassifier_GLMjl(
            featurenames,
            singlelabelname,
            singlelabelpositiveclass;
            intercept = intercept,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const binarylogisticclassifier = singlelabelbinarylogisticclassifier
