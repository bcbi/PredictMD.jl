import LIBSVM

mutable struct MutableLIBSVMjlSVMEstimator <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    levels::T4 where T4 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T5 where T5 <: Associative

    # parameters (learned from data):
    underlyingsvm::T6 where T6

    function MutableLIBSVMjlSVMEstimator(
            ;
            singlelabellevels::AbstractVector = [],
            name::AbstractString = "",
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            svmtype::Type = LIBSVM.SVC,
            kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
            degree::Integer = 3,
            gamma::AbstractFloat = 0.1,
            coef0::AbstractFloat = 0.0,
            cost::AbstractFloat = 1.0,
            nu::AbstractFloat = 0.5,
            epsilon::AbstractFloat = 0.1,
            tolerance::AbstractFloat = 0.001,
            shrinking::Bool = true,
            weights::Union{Dict, Void} = nothing,
            cachesize::AbstractFloat = 100.0,
            verbose::Bool = true,
            )
        hyperparameters = Dict()
        hyperparameters[:svmtype] = svmtype
        hyperparameters[:kernel] = kernel
        hyperparameters[:degree] = degree
        hyperparameters[:gamma] = gamma
        hyperparameters[:coef0] = coef0
        hyperparameters[:cost] = cost
        hyperparameters[:nu] = nu
        hyperparameters[:epsilon] = epsilon
        hyperparameters[:tolerance] = tolerance
        hyperparameters[:shrinking] = shrinking
        hyperparameters[:weights] = weights
        hyperparameters[:cachesize] = cachesize
        hyperparameters[:verbose] = verbose
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            singlelabellevels,
            hyperparameters,
            )
        return result
    end
end

function setfeaturecontrasts!(
        x::MutableLIBSVMjlSVMEstimator,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function get_underlying(
        x::MutableLIBSVMjlSVMEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingsvm
    return result
end

function set_underlying!(
        x::MutableLIBSVMjlSVMEstimator,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    x.underlyingsvm = object
    return nothing
end

function gethistory(
        x::MutableLIBSVMjlSVMEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::MutableLIBSVMjlSVMEstimator,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function fit!(
        estimator::MutableLIBSVMjlSVMEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probability = true
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        probability = false
    else
        error("Could not figure out if model is classification or regression")
    end
    info(string("Starting to train LIBSVM.jl model."))
    svm = LIBSVM.svmtrain(
        featuresarray,
        labelsarray;
        probability = probability,
        estimator.hyperparameters...
        )
    info(string("Finished training LIBSVM.jl model."))
    estimator.underlyingsvm = svm
    @assert(typeof(estimator.underlyingsvm.labels) <: AbstractVector)
    estimator.levels = estimator.underlyingsvm.labels
    return estimator
end

function predict(
        estimator::MutableLIBSVMjlSVMEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = singlelabelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        predictedvalues, decisionvalues = LIBSVM.svmpredict(
            estimator.underlyingsvm,
            featuresarray,
            )
        @assert(typeof(predictedvalues) <: AbstractVector)
        @assert(ndims(predictedvalues) == 1)
        @assert(typeof(decisionvalues) <: AbstractMatrix)
        @assert(ndims(decisionvalues) == 2)
        @assert(size(predictedvalues, 1) == size(decisionvalues, 2))
        @assert(size(decisionvalues, 1) == 2)
        if !( isapprox(sum(abs, decisionvalues[2, :]), 0.0) )
            msg = string(
                "sum(abs, decisionvalues[2, :]) is not approx zero. ",
                "sum abs: ",
                sum(abs, decisionvalues[2, :]),
                ". mean abs: ",
                mean(abs, decisionvalues[2, :]),
                ".",
                )
            error(msg)
        end
        if !(
                all(
                    isapprox.(
                        predictedvalues[:],
                        decisionvalues[1, :]
                        )
                    )
                )
            differences = predictedvalues[:] .- decisionvalues[1, :]
            msg = string(
                "not all predictedvalues[:] are approx equal to ",
                "decisionvalues[1, :]. sum abs difference: ",
                sum(abs, differences),
                ". mean abs difference: ",
                mean(abs, differences),
                "."
                )
            error(msg)
        end
        result = convert(Vector, vec(predictedvalues))
        return result
    else
        error("Could not figure out if model is classification or regression")
    end
end

function predict_proba(
        estimator::MutableLIBSVMjlSVMEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        estimator.levels = estimator.underlyingsvm.labels
        predictedlabels, decisionvalues = LIBSVM.svmpredict(
            estimator.underlyingsvm,
            featuresarray,
            )
        decisionvaluestransposed = transpose(decisionvalues)
        result = Dict()
        for i = 1:length(estimator.underlyingsvm.labels)
            result[estimator.underlyingsvm.labels[i]] =
                decisionvaluestransposed[:, i]
        end
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("Could not figure out if model is classification or regression")
    end
end

function _singlelabelmulticlassdataframesvmclassifier_LIBSVM(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        name::AbstractString = "",
        svmtype::Type = LIBSVM.SVC,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Void} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        featurenames,
        singlelabelname;
        levels = singlelabellevels,
        )
    svmestimator = MutableLIBSVMjlSVMEstimator(
        ;
        name = name,
        singlelabellevels = singlelabellevels,
        isclassificationmodel = true,
        isregressionmodel = false,
        svmtype = svmtype,
        kernel = kernel,
        degree = degree,
        gamma = gamma,
        coef0 = coef0,
        cost = cost,
        nu = nu,
        epsilon = epsilon,
        tolerance = tolerance,
        shrinking = shrinking,
        weights = weights,
        cachesize = cachesize,
        verbose = verbose,
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            svmestimator,
            probapackager,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelmulticlassdataframesvmclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        name::AbstractString = "",
        svmtype::Type = LIBSVM.SVC,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Void} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        )
    if package == :LIBSVMjl
        result = _singlelabelmulticlassdataframesvmclassifier_LIBSVM(
            featurenames,
            singlelabelname,
            singlelabellevels;
            name = name,
            svmtype = svmtype,
            kernel = kernel,
            degree = degree,
            gamma = gamma,
            coef0 = coef0,
            cost = cost,
            nu = nu,
            epsilon = epsilon,
            tolerance = tolerance,
            shrinking = shrinking,
            weights = weights,
            cachesize = cachesize,
            verbose = verbose,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

function _singlelabeldataframesvmregression_LIBSVM(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        name::AbstractString = "",
        svmtype::Type = LIBSVM.EpsilonSVR,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Void} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        featurenames,
        singlelabelname,
        )
    svmestimator = MutableLIBSVMjlSVMEstimator(
        ;
        name = name,
        isclassificationmodel = false,
        isregressionmodel = true,
        svmtype = svmtype,
        kernel = kernel,
        degree = degree,
        gamma = gamma,
        coef0 = coef0,
        cost = cost,
        nu = nu,
        epsilon = epsilon,
        tolerance = tolerance,
        shrinking = shrinking,
        weights = weights,
        cachesize = cachesize,
        verbose = verbose,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            svmestimator,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabeldataframesvmregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        ;
        package::Symbol = :none,
        name::AbstractString = "",
        svmtype::Type = LIBSVM.EpsilonSVR,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Void} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        )
    if package == :LIBSVMjl
        result = _singlelabeldataframesvmregression_LIBSVM(
            featurenames,
            singlelabelname;
            name = name,
            svmtype = svmtype,
            kernel = kernel,
            degree = degree,
            gamma = gamma,
            coef0 = coef0,
            cost = cost,
            nu = nu,
            epsilon = epsilon,
            tolerance = tolerance,
            shrinking = shrinking,
            weights = weights,
            cachesize = cachesize,
            verbose = verbose,
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end
