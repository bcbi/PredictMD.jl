import CUDAapi
# import GPUArrays
import Knet
import ProgressMeter
import ValueHistories

function KnetModel(
        ;
        name::AbstractString = "",
        predict_function_source::AbstractString = "",
        loss_function_source::AbstractString = "",
        predict_function::Function = identity,
        loss_function::Function = identity,
        losshyperparameters::AbstractDict = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::AbstractDict = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        isclassificationmodel::Bool = false,
        isregressionmodel::Bool = false,
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        )
    optimizersymbol2type=Dict()
    optimizersymbol2type[:Sgd] = Knet.Sgd
    optimizersymbol2type[:Momentum] = Knet.Momentum
    optimizersymbol2type[:Nesterov] = Knet.Nesterov
    optimizersymbol2type[:Rmsprop] = Knet.Rmsprop
    optimizersymbol2type[:Adagrad] = Knet.Adagrad
    optimizersymbol2type[:Adadelta] = Knet.Adadelta
    optimizersymbol2type[:Adam] = Knet.Adam
    optimizersymbol2type=fix_type(optimizersymbol2type)
    modelweightoptimizers = Knet.optimizers(
        modelweights,
        optimizersymbol2type[optimizationalgorithm];
        optimizerhyperparameters...
        )
    # lastepoch = 0
    # lastiteration = 0
    history = ValueHistories.MVHistory()
    ValueHistories.push!(
        history,
        :epoch_at_iteration,
        0,
        0,
        )
    losshyperparameters = fix_type(losshyperparameters)
    optimizerhyperparameters = fix_type(optimizerhyperparameters)
    result = KnetModel(
        name,
        isclassificationmodel,
        isregressionmodel,
        predict_function_source,
        loss_function_source,
        predict_function,
        loss_function,
        losshyperparameters,
        optimizationalgorithm,
        optimizerhyperparameters,
        minibatchsize,
        maxepochs,
        printlosseverynepochs,
        modelweights,
        modelweightoptimizers,
        history,
        )
    return result
end

"""
"""
function set_max_epochs!(
        x::KnetModel,
        new_max_epochs::Integer,
        )
    x.maxepochs = new_max_epochs
    return nothing
end

"""
"""
function get_underlying(
        x::KnetModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = (x.modelweights, x.modelweightoptimizers,)
    return result
end

"""
"""
function get_history(
        x::KnetModel;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.history
    return result
end

function parse_functions!(estimator::KnetModel)
    estimator.predict_function = eval(
        Meta.parse(
            strip(
                estimator.predict_function_source
                )
            )
        )
    estimator.loss_function = eval(
        Meta.parse(
            strip(
                estimator.loss_function_source
                )
            )
        )
    return nothing
end

"""
"""
function fit!(
        estimator::KnetModel,
        training_features_array::AbstractArray,
        training_labels_array::AbstractArray,
        tuning_features_array::Union{Nothing, AbstractArray} = nothing,
        tuning_labels_array::Union{Nothing, AbstractArray} = nothing,
        )
    has_tuning_data::Bool =
        !is_nothing(tuning_labels_array) && !is_nothing(tuning_features_array)
    training_features_array = Float64.(training_features_array)
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        training_labels_array = Int.(training_labels_array)
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        training_labels_array = Float64.(training_labels_array)
    else
        error(
            "Could not figure out if model is classification or regression"
            )
    end
    training_data = Knet.minibatch(
        training_features_array,
        training_labels_array,
        estimator.minibatchsize,
        )
    loss_function_gradient = Knet.grad(
        estimator.loss_function,
        2,
        )
    all_iterations_so_far, all_epochs_so_far = ValueHistories.get(
        estimator.history,
        :epoch_at_iteration,
        )
    last_iteration = all_iterations_so_far[end]
    last_epoch = all_epochs_so_far[end]
    @info(
        string(
            "Starting to train Knet model. Max epochs: ",
            estimator.maxepochs,
            ".",
            )
        )
    training_lossbeforetrainingstarts = estimator.loss_function(
        estimator.predict_function,
        estimator.modelweights,
        training_features_array,
        training_labels_array;
        estimator.losshyperparameters...
        )
    if has_tuning_data
        tuning_lossbeforetrainingstarts = estimator.loss_function(
           estimator.predict_function,
           estimator.modelweights,
           tuning_features_array,
           tuning_labels_array;
           estimator.losshyperparameters...
           )
    end
    if (estimator.printlosseverynepochs) > 0
        if has_tuning_data
            @info(
                string(
                    "Epoch: ",
                    last_epoch,
                    ". Loss (training set): ",
                    training_lossbeforetrainingstarts,
                    ". Loss (tuning set): ",
                    tuning_lossbeforetrainingstarts,
                    ".",
                    )
                )
        else
            @info(
                string(
                    "Epoch: ",
                    lastepoch,
                    ". Loss: ",
                    lossbeforetrainingstarts,
                    "."
                    )
                )
        end
    end
    while last_epoch < estimator.maxepochs
        for (x_training, y_training) in training_data
            grads = loss_function_gradient(
                estimator.predict_function,
                estimator.modelweights,
                x_training,
                y_training;
                estimator.losshyperparameters...
                )
            Knet.update!(
                estimator.modelweights,
                grads,
                estimator.modelweightoptimizers,
                )
            last_iteration += 1
            training_currentiterationloss = estimator.loss_function(
                estimator.predict_function,
                estimator.modelweights,
                x_training,
                y_training;
                estimator.losshyperparameters...
                )
            ValueHistories.push!(
                estimator.history,
                :training_loss_at_iteration,
                last_iteration,
                training_currentiterationloss,
                )
        end # end for
        last_epoch += 1
        ValueHistories.push!(
            estimator.history,
            :epoch_at_iteration,
            last_iteration,
            last_epoch,
            )
        training_currentepochloss = estimator.loss_function(
            estimator.predict_function,
            estimator.modelweights,
            training_features_array,
            training_labels_array;
            estimator.losshyperparameters...
            )
        ValueHistories.push!(
            estimator.history,
            :training_loss_at_epoch,
            last_epoch,
            training_currentepochloss,
            )
        if has_tuning_data
            tuning_currentepochloss = estimator.loss_function(
                estimator.predict_function,
                estimator.modelweights,
                tuning_features_array,
                tuning_labels_array;
                estimator.losshyperparameters...
                )
            ValueHistories.push!(
                estimator.history,
                :tuning_loss_at_epoch,
                last_epoch,
                tuning_currentepochloss,
                )
        end
        printlossthisepoch = (estimator.printlosseverynepochs > 0) &&
            ( (last_epoch == estimator.maxepochs) ||
                ( (last_epoch %
                    estimator.printlosseverynepochs) == 0 ) )
        if printlossthisepoch
            if has_tuning_data
                @info(
                   string(
                       "Epoch: ",
                       last_epoch,
                       ". Loss (training set): ",
                       training_currentepochloss,
                       ". Loss (tuning set): ",
                       tuning_currentepochloss,
                       ".",
                       ),
                   )
            else
                @info(
                   string(
                       "Epoch: ",
                       last_epoch,
                       ". Loss: ",
                       training_currentepochloss,
                       ".",
                       ),
                   )
            end
        end
    end # end while
    @info(string("Finished training Knet model."))
    return estimator
end

"""
"""
function predict(
        estimator::KnetModel,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = single_labelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif estimator.isregressionmodel
        output = estimator.predict_function(
            estimator.modelweights,
            featuresarray;
            )
        outputtransposed = transpose(output)
        result = convert(Array, outputtransposed)
        return result
    else
        error("unable to predict")
    end
end

"""
"""
function predict(
        estimator::KnetModel,
        featuresarray::AbstractArray,
        positive_class::Integer,
        threshold::AbstractFloat,
        )
    if estimator.isclassificationmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = single_labelprobabilitiestopredictions(
            probabilitiesassoc,
            positive_class,
            threshold,
            )
        return predictionsvector
    else
        error("can only use the `threshold` argument with classification models")
    end
end

"""
"""
function predict_proba(
        estimator::KnetModel,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        output = estimator.predict_function(
            estimator.modelweights,
            featuresarray;
            probabilities = true,
            )
        outputtransposed = transpose(output)
        numclasses = size(outputtransposed, 2)
        result = Dict()
        for i = 1:numclasses
            result[i] = outputtransposed[:, i]
        end
        return result
    elseif estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("unable to predict")
    end
end

"""
"""
function single_labelmulticlassdataframeknetclassifier_Knet(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        name::AbstractString = "",
        predict_function_source::AbstractString = "",
        loss_function_source::AbstractString = "",
        losshyperparameters::AbstractDict = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::AbstractDict = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
            nothing,
        )
    label_names = [single_label_name]
    label_levels = Dict()
    label_levels[single_label_name] = single_label_levels
    label_levels = fix_type(label_levels)
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = MutableDataFrame2ClassificationKnetTransformer(
        feature_names,
        label_names,
        label_levels,
        dftransformer_index;
        transposefeatures = dftransformer_transposefeatures,
        transposelabels = dftransformer_transposelabels,
        )
    knetestimator = KnetModel(
        ;
        name = name,
        predict_function_source = predict_function_source,
        loss_function_source = loss_function_source,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        minibatchsize = minibatchsize,
        modelweights = modelweights,
        isclassificationmodel = true,
        isregressionmodel = false,
        maxepochs = maxepochs,
        printlosseverynepochs = printlosseverynepochs,
        )
    predprobalabelfixer =
            ImmutablePredictProbaSingleLabelInt2StringTransformer(
                        1,
                        single_label_levels
                        )
    predictlabelfixer =
            ImmutablePredictionsSingleLabelInt2StringTransformer(
                        1,
                        single_label_levels
                        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        single_label_name,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        single_label_name,
        )
    finalpipeline = dftransformer |>
                    knetestimator |>
                    predprobalabelfixer |>
                    predictlabelfixer |>
                    probapackager |>
                    predpackager
    finalpipeline.name = name
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
function single_labelmulticlassdataframeknetclassifier(
        feature_names::AbstractVector,
        single_label_name::Symbol,
        single_label_levels::AbstractVector;
        package::Symbol = :none,
        name::AbstractString = "",
        predict_function_source::AbstractString = "",
        loss_function_source::AbstractString = "",
        losshyperparameters::AbstractDict = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::AbstractDict = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
            nothing,
        )
    if package == :Knet
        result = single_labelmulticlassdataframeknetclassifier_Knet(
            feature_names,
            single_label_name,
            single_label_levels;
            name = name,
            predict_function_source = predict_function_source,
            loss_function_source = loss_function_source,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            minibatchsize = minibatchsize,
            modelweights = modelweights,
            maxepochs = maxepochs,
            printlosseverynepochs = printlosseverynepochs,
            feature_contrasts = feature_contrasts
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

"""
"""
function single_labeldataframeknetregression_Knet(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        name::AbstractString = "",
        predict_function_source::AbstractString = "",
        loss_function_source::AbstractString = "",
        losshyperparameters::AbstractDict = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::AbstractDict = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
            nothing,
        )
    label_names = [single_label_name]
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = MutableDataFrame2RegressionKnetTransformer(
        feature_names,
        label_names;
        transposefeatures = true,
        transposelabels = true,
        )
    knetestimator = KnetModel(
        ;
        name = name,
        predict_function_source = predict_function_source,
        loss_function_source = loss_function_source,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        minibatchsize = minibatchsize,
        modelweights = modelweights,
        isclassificationmodel = false,
        isregressionmodel = true,
        maxepochs = maxepochs,
        printlosseverynepochs = printlosseverynepochs,
        )
    predpackager = ImmutablePackageMultiLabelPredictionTransformer(
        [single_label_name,],
        )
    finalpipeline = dftransformer |>
                    knetestimator |>
                    predpackager
    finalpipeline.name = name
    if !is_nothing(feature_contrasts)
        set_feature_contrasts!(finalpipeline, feature_contrasts)
    end
    return finalpipeline
end

"""
"""
function single_labeldataframeknetregression(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        package::Symbol = :none,
        name::AbstractString = "",
        predict_function_source::AbstractString = "",
        loss_function_source::AbstractString = "",
        losshyperparameters::AbstractDict = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::AbstractDict = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        feature_contrasts::Union{Nothing, AbstractFeatureContrasts} =
            nothing,
        )
    if package == :Knet
        result = single_labeldataframeknetregression_Knet(
            feature_names,
            single_label_name;
            name = name,
            predict_function_source = predict_function_source,
            loss_function_source = loss_function_source,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            minibatchsize = minibatchsize,
            modelweights = modelweights,
            maxepochs = maxepochs,
            printlosseverynepochs = printlosseverynepochs,
            feature_contrasts = feature_contrasts
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end
