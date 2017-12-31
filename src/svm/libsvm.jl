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
    levels::T2 where T2 <: AbstractVector

    # hyperparameters (not learned from data):
    # TODO: add SVM hyperparameters here

    # parameters (learned from data):
    svmmodel::T3 where T3

    function ASBLIBSVMjlSVMClassifier(
            singlelabellevels::AbstractVector;
            name::AbstractString = "",
            )
        return new(name, singlelabellevels)
    end
end

function underlying(x::AbstractASBLIBSVMjlSVMClassifier)
    result = x.svmmodel
    return result
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
    estimator.levels = estimator.svmmodel.labels
    predictedlabels, decisionvalues = LIBSVM.svmpredict(
        estimator.svmmodel,
        featuresarray,
        )
    decisionvaluestransposed = transpose(decisionvalues)
    result = Dict()
    for i = 1:length(estimator.svmmodel.labels)
        result[estimator.svmmodel.labels[i]] = decisionvaluestransposed[:, i]
    end
    return result
end

function _singlelabelsvmclassifier_LIBSVMjl(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        )
    dftransformer = DataFrame2LIBSVMjlTransformer(
        featurenames,
        singlelabelname,
        singlelabellevels,
        df,
        )
    svmestimator = ASBLIBSVMjlSVMClassifier(
        singlelabellevels;
        name = name,
        )
    probapackager = PackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = SimplePipeline(
        [
            dftransformer,
            svmestimator,
            probapackager,
            ];
        name = name,
        underlyingobjectindex = 2,
        )
    return finalpipeline
end

function singlelabelsvmclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        package::Symbol = :none,
        )
    if package == :LIBSVMjl
        result = _singlelabelsvmclassifier_LIBSVMjl(
            featurenames,
            singlelabelname,
            singlelabellevels,
            df;
            name = name,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const svmclassifier = singlelabelsvmclassifier
