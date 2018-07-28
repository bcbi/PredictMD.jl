##### Beginning of file

import LIBSVM

"""
"""
mutable struct LIBSVMModel <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    levels::T4 where T4 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T5 where T5 <: Associative

    # parameters (learned from data):
    underlyingsvm::T6 where T6 <: Union{Void, LIBSVM.SVM}

    function LIBSVMModel(
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
        weights = fix_dict_type(weights)
        hyperparameters[:weights] = weights
        hyperparameters[:cachesize] = cachesize
        hyperparameters[:verbose] = verbose
        hyperparameters = fix_dict_type(hyperparameters)
        underlyingsvm = nothing
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            singlelabellevels,
            hyperparameters,
            underlyingsvm,
            )
        return result
    end
end

"""
"""
function set_feature_contrasts!(
        x::LIBSVMModel,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::LIBSVMModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.underlyingsvm
    return result
end

"""
"""
function get_history(
        x::LIBSVMModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(estimator::LIBSVMModel)
    return nothing
end

"""
"""
function fit!(
        estimator::LIBSVMModel,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        probability = true
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        probability = false
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
    info(string("Starting to train LIBSVM model."))
    svm = try
        LIBSVM.svmtrain(
            featuresarray,
            labelsarray;
            probability = probability,
            estimator.hyperparameters...
            )
    catch e
        warn(
            string(
                "While training LIBSVM model, ignored error: ",
                e,
                )
            )
        nothing
    end
    # svm =
    info(string("Finished training LIBSVM model."))
    estimator.underlyingsvm = svm
    estimator.levels = estimator.underlyingsvm.labels
    return estimator
end

"""
"""
function predict(
        estimator::LIBSVMModel,
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
        if is_nothing(estimator.underlyingsvm)
            predicted_values = zeros(size(featuresarray, 2))
        else
            predicted_values, decision_values = LIBSVM.svmpredict(
                estimator.underlyingsvm,
                featuresarray,
                )
            if !(typeof(predicted_values) <: AbstractVector)
                error("!(typeof(predicted_values) <: AbstractVector)")
            end
        end
        return predicted_values
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
end

"""
"""
function predict_proba(
        estimator::LIBSVMModel,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        if is_nothing(estimator.underlyingsvm)
            decision_values = zeros(
                size(featuresarray, 2),
                length(estimator.underlyingsvm.labels),
                )
            decision_values[:, 1] = 1
        else
            predicted_labels, decision_values =
                LIBSVM.svmpredict(estimator.underlyingsvm,featuresarray,)
            decision_values = transpose(decision_values)
        end
        result = Dict()
        for i = 1:length(estimator.underlyingsvm.labels)
            result[estimator.underlyingsvm.labels[i]] =
                decision_values[:, i]
        end
        result = fix_dict_type(result)
        return result
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
end

"""
"""
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
        feature_contrasts::Union{Void, AbstractFeatureContrasts} =
            nothing,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        featurenames,
        singlelabelname;
        levels = singlelabellevels,
        )
    svmestimator = LIBSVMModel(
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
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            svmestimator,
            probapackager,
            predpackager,
            ];
        name = name,
        )
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
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
        feature_contrasts::Union{Void, AbstractFeatureContrasts} = nothing,
        )
    if package == :LIBSVM
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
            feature_contrasts = feature_contrasts
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

"""
"""
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
        feature_contrasts::Union{Void, AbstractFeatureContrasts} =
                nothing,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        featurenames,
        singlelabelname,
        )
    svmestimator = LIBSVMModel(
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
    finalpipeline = SimplePipeline(
        Fittable[
            dftransformer,
            svmestimator,
            predpackager,
            ];
        name = name,
        )
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
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
        feature_contrasts::Union{Void, AbstractFeatureContrasts} = nothing,
        )
    if package == :LIBSVM
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
            feature_contrasts = feature_contrasts
        )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

##### End of file
