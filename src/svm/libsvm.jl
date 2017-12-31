import LIBSVM

abstract type AbstractASBLIBSVMjlSVMClassifier <:
        AbstractClassifier
end

abstract type AbstractASBLIBSVMjlSVMtRegression <:
        AbstractRegression
end

mutable struct ASBLIBSVMjlSVMClassifier <:
        AbstractASBLIBSVMjlSVMClassifier
    name::T1 where T1 <: AbstractString
    singlelabelname::T2 where T2 <: Symbol
    levels::T3 where T3 <: AbstractVector
    # hyperparameters (not learned from data):
    # TODO: add SVM hyperparameters here
    # parameters (learned from data):
    svmmodel::T4 where T4

    function ASBLIBSVMjlSVMClassifier(
            singlelabelname::Symbol,
            levels::AbstractVector;
            name::AbstractString = "",
            )
        return new(name, singlelabelname, levels)
    end
end

function fit!(
        estimator::AbstractASBLIBSVMjlSVMClassifier,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    svmmodel = LIBSVM.svmtrain(
        featuresarray,
        labelsarray;
        probability = true,
        )
    estimator.svmmodel = svmmodel
    @assert(typeof(estimator.svmmodel.labels) <: AbstractVector)
    estimator.levels = estimator.svmmodel.labels
    return estimator
end

function predict_proba(
        estimator::AbstractASBLIBSVMjlSVMClassifier,
        featuresarray::AbstractArray,
        )
    predictedlabels, decisionvalues = LIBSVM.svmpredict(
        estimator.svmmodel,
        featuresarray,
        )
    decisionvaluestransposed = transpose(decisionvalues)
    labelresult = Dict()
    for i = 1:length(estimator.svmmodel.labels)
        labelresult[estimator.svmmodel.labels[i]] =
            decisionvaluestransposed[:, i]
    end
    allresults = Dict()
    allresults[estimator.singlelabelname] = labelresult
    return allresults
end

function _singlelabelsvmclassifier_LIBSVMjl(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        )
    dftransformer = DataFrame2LIBSVMjlTransformer(
        featurenames,
        singlelabelname,
        levels,
        df,
        )
    svmestimator = ASBLIBSVMjlSVMClassifier(
        singlelabelname,
        levels;
        name = name,
        )
    finalobjectsvector = [dftransformer, svmestimator]
    finalpipeline = SimplePipeline(finalobjectsvector; name = name)
    return finalpipeline
end

function singlelabelsvmclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        package::Symbol = :none,
        )
    if package == :LIBSVMjl
        result = _singlelabelsvmclassifier_LIBSVMjl(
            featurenames,
            singlelabelname,
            levels,
            df;
            name = name,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const svmclassifier = singlelabelsvmclassifier
