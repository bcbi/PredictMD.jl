##### Beginning of file

import LIBSVM

function LIBSVMModel(
        ;
        single_label_levels::AbstractVector = [],
        name::AbstractString = "",
        isclassificationmodel::Bool = false,
        isregressionmodel::Bool = false,
        svmtype::Type=LIBSVM.SVC,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Nothing} = nothing,
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
    weights = fix_type(weights)
    hyperparameters[:weights] = weights
    hyperparameters[:cachesize] = cachesize
    hyperparameters[:verbose] = verbose
    hyperparameters = fix_type(hyperparameters)
    underlyingsvm = FitNotYetRunUnderlyingObject()
    result = LIBSVMModel(
        name,
        isclassificationmodel,
        isregressionmodel,
        single_label_levels,
        hyperparameters,
        underlyingsvm,
        )
    return result
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
    @info(string("Starting to train LIBSVM model."))
    svm = try
        LIBSVM.svmtrain(
            featuresarray,
            labelsarray;
            probability = probability,
            estimator.hyperparameters...
            )
    catch e
        @warn(
            string(
                "While training LIBSVM model, ignored error: ",
                e,
                )
            )
        FitFailedUnderlyingObject()
    end
    # svm =
    @info(string("Finished training LIBSVM model."))
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
        predictionsvector = single_labelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        if is_nothing(estimator.underlyingsvm)
            predicted_values = fill(Cfloat(0), size(featuresarray, 2))
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
            decision_values = fill(
                Int(0),
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
        result = fix_type(result)
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
function single_labelmulticlassdataframesvmclassifier_LIBSVM(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        name::AbstractString = "",
        svmtype::Type=LIBSVM.SVC,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Nothing} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
            nothing,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        feature_names,
        single_label_name;
        levels = single_label_levels,
        )
    svmestimator = LIBSVMModel(
        ;
        name = name,
        single_label_levels = single_label_levels,
        isclassificationmodel = true,
        isregressionmodel = false,
        svmtype=svmtype,
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
        single_label_name,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        single_label_name,
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
function single_labelmulticlassdataframesvmclassifier(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        package::Symbol = :none,
        name::AbstractString = "",
        svmtype::Type=LIBSVM.SVC,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Nothing} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    if package == :LIBSVM
        result = single_labelmulticlassdataframesvmclassifier_LIBSVM(
            feature_names,
            single_label_name,
            single_label_levels;
            name = name,
            svmtype=svmtype,
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
function single_labeldataframesvmregression_LIBSVM(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        name::AbstractString = "",
        svmtype::Type=LIBSVM.EpsilonSVR,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Nothing} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
                nothing,
        )
    dftransformer = DataFrame2LIBSVMTransformer(
        feature_names,
        single_label_name,
        )
    svmestimator = LIBSVMModel(
        ;
        name = name,
        isclassificationmodel = false,
        isregressionmodel = true,
        svmtype=svmtype,
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
        single_label_name,
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
function single_labeldataframesvmregression(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        ;
        package::Symbol = :none,
        name::AbstractString = "",
        svmtype::Type=LIBSVM.EpsilonSVR,
        kernel::LIBSVM.Kernel.KERNEL = LIBSVM.Kernel.RadialBasis,
        degree::Integer = 3,
        gamma::AbstractFloat = 0.1,
        coef0::AbstractFloat = 0.0,
        cost::AbstractFloat = 1.0,
        nu::AbstractFloat = 0.5,
        epsilon::AbstractFloat = 0.1,
        tolerance::AbstractFloat = 0.001,
        shrinking::Bool = true,
        weights::Union{Dict, Nothing} = nothing,
        cachesize::AbstractFloat = 100.0,
        verbose::Bool = true,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} = nothing,
        )
    if package == :LIBSVM
        result = single_labeldataframesvmregression_LIBSVM(
            feature_names,
            single_label_name;
            name = name,
            svmtype=svmtype,
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
