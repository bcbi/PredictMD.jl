import DataFrames
import GLM
import StatsModels

abstract type AbstractASBGLMjlGeneralizedLinearModelClassifier <:
        AbstractClassifier
end

abstract type AbstractASBGLMjlGeneralizedLinearModelRegression <:
        AbstractClassifier
end

mutable struct ASBGLMjlGeneralizedLinearModelClassifier <:
        AbstractASBGLMjlGeneralizedLinearModelClassifier
    # hyperparameters (not learned from data):
    formula::T1 where T1 <: StatsModels.Formula
    family::T2 where T2 <: GLM.Distribution
    link::T3 where T3 <: GLM.Link

    # parameters (learned from data):
    glm::T4 where T4

    function ASBGLMjlGeneralizedLinearModelClassifier(
            formula::TT1,
            family::TT2,
            link::TT3,
            ) where
            TT1 <: StatsModels.Formula where
            TT2 <: GLM.Distribution where
            TT3 <: GLM.Link
        return new(formula, family, link)
    end
end

mutable struct ASBGLMjlGeneralizedLinearModelRegression <:
        AbstractASBGLMjlGeneralizedLinearModelRegression
    # hyperparameters (not learned from data):
    formula::T1 where T1 <: StatsModels.Formula
    family::T2 where T2 <: GLM.Distribution
    link::T3 where T3 <: GLM.Link

    # parameters (learned from data):
    glm::T4 where T4

    function ASBGLMjlGeneralizedLinearModelRegression(
            formula::TT1,
            family::TT2,
            link::TT3,
            ) where
            TT1 <: StatsModels.Formula where
            TT2 <: GLM.Distribution where
            TT3 <: GLM.Link
        return new(formula, family, link)
    end
end

function underlying(
        x::T,
        ) where
        T <: AbstractASBGLMjlGeneralizedLinearModelClassifier
    return Nullable(x.glm)
end
function underlying(
        x::T,
        ) where
        T <: AbstractASBGLMjlGeneralizedLinearModelRegression
    return Nullable(x.glm)
end

function fit!(
        estimator::T1,
        featuresdf::T2,
        labelsdf::T3,
        ) where
        T1 <: AbstractASBGLMjlGeneralizedLinearModelClassifier where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame
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
        estimator::T1,
        featuresdf::T2,
        ) where
        T1 <: AbstractASBGLMjlGeneralizedLinearModelClassifier where
        T2 <: DataFrames.AbstractDataFrame
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
        estimator::T1,
        featuresdf::T2,
        labelsdf::T3,
        ) where
        T1 <: AbstractASBGLMjlGeneralizedLinearModelRegression where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame
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

# function predict(
#         estimator::T1,
#         featuresdf::T2,
#         ) where
#         T1 <: AbstractASBGLMjlGeneralizedLinearModelRegression where
#         T2 <: DataFrames.AbstractDataFrame
# end

function _singlelabelbinarylogisticclassifier_glmjl(
        featurenames::T1,
        singlelabelname::T2,
        singlelabelpositiveclass::T3;
        intercept::T5 = true,
        name::N = "",
        ) where
        T1 <: AbstractVector where
        T2 <: Symbol where
        T3 <: AbstractString where
        T5 <: Bool where
        N <: AbstractString
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
        featurenames::T1,
        singlelabelname::T2,
        singlelabelpositiveclass::T3;
        package::T4 = :GLMjl,
        intercept::T5 = true,
        name::N = "",
        ) where
        T1 <: AbstractVector where
        T2 <: Symbol where
        T3 <: AbstractString where
        T4 <: Symbol where
        T5 <: Bool where
        N <: AbstractString
    if package == :GLMjl
        result =_singlelabelbinarylogisticclassifier_glmjl(
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
