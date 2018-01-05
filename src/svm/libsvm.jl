import LIBSVM

mutable struct MutableLIBSVMEstimator <: AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    levels::T4 where T4 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T5 where T5 <: Associative

    # parameters (learned from data):
    underlyingsvm::T6 where T6

    function MutableLIBSVMEstimator(
            singlelabellevels::AbstractVector;
            name::AbstractString = "",
            )
        hyperparameters = Dict()
        result = new(
            )
        return result
    end
end

function underlying(x::MutableLIBSVMEstimator)
    result = x.svmmodel
    return result
end

function fit!(
        estimator::MutableLIBSVMEstimator,
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

function predict(
        estimator::MutableLIBSVMEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        error("predict is not defined for classification models")
    elseif estimator.isregressionmodel
    else
        error("unable to predict")
    end
end

function predict_proba(
        estimator::MutableLIBSVMEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
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
    elseif estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("unable to predict")
    end
end

function _singlelabelsvmclassifier_LIBSVM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        featurenames,
        singlelabelname,
        singlelabellevels,
        df,
        )
    svmestimator = MutableLIBSVMEstimator(
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
    if package == :LIBSVM
        result = _singlelabelsvmclassifier_LIBSVM(
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
