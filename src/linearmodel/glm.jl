import DataFrames
import GLM
import StatsModels


mutable struct MutableGLMjlGeneralizedLinearModelEstimator <:
        AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    formula::T4 where T4 <: StatsModels.Formula
    family::T5 where T5 <: GLM.Distribution
    link::T6 where T6 <: GLM.Link

    # parameters (learned from data):
    underlyingglm::T where T

    function MutableGLMjlGeneralizedLinearModelEstimator(
            formula::StatsModels.Formula,
            family::GLM.Distribution,
            link::GLM.Link;
            name::AbstractString = "",
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            )
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            formula,
            family,
            link,
            )
        return result
    end
end

function underlying(x::MutableGLMjlGeneralizedLinearModelEstimator)
    result = x.underlyingglm
    return result
end

function fit!(
        estimator::MutableGLMjlGeneralizedLinearModelEstimator,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        )
    labelsandfeaturesdf = hcat(labelsdf, featuresdf)
    info(string("Starting to train GLM.jl model..."))
    glm = GLM.glm(
        estimator.formula,
        labelsandfeaturesdf,
        estimator.family,
        estimator.link,
        )
    info(string("Finished training GLM.jl model."))
    estimator.underlyingglm = glm
    return estimator
end

function predict(
        estimator::MutableGLMjlGeneralizedLinearModelEstimator,
        featuresdf::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel
        error("predict is not defined for classification models")
    elseif estimator.isregressionmodel
        glmpredictoutput = GLM.predict(
            estimator.underlyingglm,
            featuresdf,
            )
        result = DataFrames.DataFrame()
        labelname = estimator.formula.lhs
        @assert(typeof(labelname) <: Symbol)
        result[labelname] = glmpredictoutput
        return result
    else
        error("unable to predict")
    end

end

function predict_proba(
        estimator::MutableGLMjlGeneralizedLinearModelEstimator,
        featuresdf::DataFrames.AbstractDataFrame,
        )
    if estimator.isclassificationmodel
        glmpredictoutput = GLM.predict(
            estimator.underlyingglm,
            featuresdf,
            )
        result = Dict()
        result[1] = glmpredictoutput
        result[0] = 1 - glmpredictoutput
        return result
    elseif estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("unable to predict_proba")
    end

end

function _singlelabelbinarylogisticclassifier_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        intercept::Bool = true,
        name::AbstractString = "",
        )
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    formula = makeformula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        )
    dftransformer = ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = MutableGLMjlGeneralizedLinearModelEstimator(
        formula,
        GLM.Binomial(),
        GLM.LogitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predprobafixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            glmestimator,
            predprobafixer,
            probapackager,
            ];
        name = name,
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

function _singlelabelbinaryprobitclassifier_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        intercept::Bool = true,
        name::AbstractString = "",
        )
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    formula = makeformula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        )
    dftransformer = ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer(
        singlelabelname,
        positiveclass,
        )
    glmestimator = MutableGLMjlGeneralizedLinearModelEstimator(
        formula,
        GLM.Binomial(),
        GLM.ProbitLink();
        isclassificationmodel = true,
        isregressionmodel = false,
        )
    predprobafixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        0,
        singlelabellevels,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            glmestimator,
            predprobafixer,
            probapackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelbinaryprobitclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        intercept::Bool = true,
        name::AbstractString = "",
        )
    if package == :GLM
        result =_singlelabelbinaryprobitclassifier_GLM(
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

const binaryprobitclassifier = singlelabelbinaryprobitclassifier


function _singlelabellinearregression_GLM(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        intercept::Bool = true,
        name::AbstractString = "",
        )
    formula = makeformula(
        [singlelabelname],
        featurenames;
        intercept = intercept,
        )
    glmestimator = MutableGLMjlGeneralizedLinearModelEstimator(
        formula,
        GLM.Normal(),
        GLM.IdentityLink();
        isclassificationmodel = false,
        isregressionmodel = true,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            glmestimator,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabellinearregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        package::Symbol = :none,
        intercept::Bool = true,
        name::AbstractString = "",
        )
    if package == :GLMjl
        result =_singlelabellinearregression_GLM(
            featurenames,
            singlelabelname;
            intercept = intercept,
            name = name,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const linearregression = singlelabellinearregression
