import Knet
import StatsFuns
import ValueHistories

function _emptyfunction()
end

mutable struct MutableKnetjlNeuralNetworkEstimator <: AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T2 where T2 <: Bool

    # hyperparameters (not learned from data):
    predict::T3 where T3 <: Function
    loss::T4 where T4 <: Function
    losshyperparameters::T5 where T5 <: Associative
    optimizationalgorithm::T6 where T6 <: Symbol
    optimizerhyperparameters::T7 where T7 <: Associative
    batchsize::T8 where T8 <: Integer
    maxepochs::T9 where T9 <: Integer

    # parameters (learned from data):
    modelweights::T10 where T10 <: AbstractArray
    modelweightoptimizers::T11 where T11

    # learning state
    lastepoch::T12 where T12 <: Integer
    lastiteration::T13 where T13 <: Integer
    valuehistories::T14 where T14 <: ValueHistories.MultivalueHistory
    printlosseverynepochs::T15 where T15 <: Integer

    function MutableKnetjlNeuralNetworkEstimator(
            ;
            name::AbstractString = "",
            predict::Function = _emptyfunction,
            loss::Function =_emptyfunction,
            losshyperparameters::Associative = Dict(),
            optimizationalgorithm::Symbol = :nothing,
            optimizerhyperparameters::Associative = Dict(),
            batchsize::Integer = 0,
            modelweights::AbstractArray = [],
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            printlosseverynepochs::Integer = 0,
            maxepochs::Integer = 0,
            )
        optimizersymbol2type = Dict()
        optimizersymbol2type[:Sgd] = Knet.Sgd
        optimizersymbol2type[:Momentum] = Knet.Momentum
        optimizersymbol2type[:Nesterov] = Knet.Nesterov
        optimizersymbol2type[:Rmsprop] = Knet.Rmsprop
        optimizersymbol2type[:Adagrad] = Knet.Adagrad
        optimizersymbol2type[:Adadelta] = Knet.Adadelta
        optimizersymbol2type[:Adam] = Knet.Adam
        modelweightoptimizers = Knet.optimizers(
            modelweights,
            optimizersymbol2type[optimizationalgorithm];
            optimizerhyperparameters...
            )
        lastepoch = 0
        lastiteration = 0
        valuehistories = ValueHistories.MVHistory()
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            predict,
            loss,
            losshyperparameters,
            optimizationalgorithm,
            optimizerhyperparameters,
            batchsize,
            maxepochs,
            modelweights,
            modelweightoptimizers,
            lastepoch,
            lastiteration,
            valuehistories,
            printlosseverynepochs,
            )
        return result
    end
end

function underlying(x::MutableKnetjlNeuralNetworkEstimator)
    result = (predictfunction, modelweightsmodelweights)
    return result
end

function valuehistories(x::MutableKnetjlNeuralNetworkEstimator)
    result = x.valuehistories
    return result
end

function fit!(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    featuresarray = Cfloat.(featuresarray)
    labelsarray = Cfloat.(labelsarray)
    trainingdata = Knet.minibatch(
        featuresarray,
        labelsarray,
        estimator.batchsize,
        )
    lossgradient = Knet.grad(
        estimator.loss,
        2,
        )
    lossbeforetrainingstarts = estimator.loss(
        estimator.predict,
        estimator.modelweights,
        featuresarray,
        labelsarray;
        estimator.losshyperparameters...
        )
    info(
        "Loss before training starts: ",
        lossbeforetrainingstarts,
        )
    info(
        string("Max epochs: "),
        estimator.maxepochs,
        )
    info(string("Starting to train Knet.jl model..."))
    while estimator.lastepoch < estimator.maxepochs
        for (x,y) in trainingdata
            grads = lossgradient(
                estimator.predict,
                estimator.modelweights,
                x,
                y;
                estimator.losshyperparameters...
                )
            Knet.update!(
                estimator.modelweights,
                grads,
                estimator.modelweightoptimizers,
                )
            estimator.lastiteration += 1
            currentiterationloss = estimator.loss(
                estimator.predict,
                estimator.modelweights,
                x,
                y;
                estimator.losshyperparameters...
                )
            ValueHistories.push!(
                estimator.valuehistories,
                :lossatiteration,
                estimator.lastiteration,
                currentiterationloss,
                )
        end # end for
        estimator.lastepoch += 1
        ValueHistories.push!(
            estimator.valuehistories,
            :epochatiteration,
            estimator.lastiteration,
            estimator.lastepoch,
            )
        currentepochloss = estimator.loss(
            estimator.predict,
            estimator.modelweights,
            featuresarray,
            labelsarray;
            estimator.losshyperparameters...
            )
        ValueHistories.push!(
            estimator.valuehistories,
            :lossatepoch,
            estimator.lastepoch,
            currentepochloss,
            )
        if (estimator.printlosseverynepochs > 0) &&
                ( (estimator.lastepoch %
                    estimator.printlosseverynepochs) == 0 )
            info(
                string(
                    "Epoch: ",
                    estimator.lastepoch,
                    ". Loss: ",
                    currentepochloss,
                    ".",
                    ),
                )
        end
    end # end while
    info(string("Finished training Knet.jl model."))
    return estimator
end

function predict(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        error("predict is not defined for classification models")
    elseif estimator.isregressionmodel
        output = estimator.predict(
            estimator.modelweights,
            featuresarray;
            training = false,
            )
        outputtransposed = transpose(output)
        result = convert(Array, outputtransposed)
        return result
    else
        error("unable to predict")
    end
end

function predict_proba(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        output = estimator.predict(
            estimator.modelweights,
            featuresarray;
            training = false,
            )
        outputtransposed = transpose(output)
        numclasses = size(outputtransposed, 2)
        @assert(numclasses > 0)
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

function _singlelabelknetclassifier_Knet(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        dffeaturecontrasts::AbstractContrastsObject;
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        batchsize::Integer = 0,
        modelweights::AbstractArray = [],
        printlosseverynepochs::Integer = 0,
        maxepochs::Integer = 0,
        )
    labelnames = [singlelabelname]
    labellevels = Dict()
    labellevels[singlelabelname] = singlelabellevels
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = ImmutableDataFrame2ClassificationKnetTransformer(
        featurenames,
        dffeaturecontrasts,
        labelnames,
        labellevels,
        dftransformer_index,
        dftransformer_transposefeatures,
        dftransformer_transposelabels,
        )
    knetestimator = MutableKnetjlNeuralNetworkEstimator(
        ;
        name = name,
        predict = predict,
        loss = loss,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        batchsize = batchsize,
        modelweights = modelweights,
        isclassificationmodel = true,
        isregressionmodel = false,
        printlosseverynepochs = printlosseverynepochs,
        io = io,
        maxepochs = maxepochs,
        )
    predprobafixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        1,
        singlelabellevels
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            knetestimator,
            predprobafixer,
            probapackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelknetclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        dffeaturecontrasts::AbstractContrastsObject;
        package::Symbol = :none,
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        batchsize::Integer = 0,
        modelweights::AbstractArray = [],
        printlosseverynepochs::Integer = 0,
        maxepochs::Integer = 0,
        )
    if package == :Knetjl
        result = _singlelabelknetclassifier_Knet(
            featurenames,
            singlelabelname,
            singlelabellevels,
            dffeaturecontrasts;
            name = name,
            predict = predict,
            loss = loss,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            batchsize = batchsize,
            modelweights = modelweights,
            printlosseverynepochs = printlosseverynepochs,
            io = io,
            maxepochs = maxepochs,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const knetclassifier = singlelabelknetclassifier

function _singlelabelknetregression_Knet(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        dffeaturecontrasts::AbstractContrastsObject;
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        batchsize::Integer = 0,
        modelweights::AbstractArray = [],
        printlosseverynepochs::Integer = 0,
        maxepochs::Integer = 0,
        )
    labelnames = [singlelabelname]
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = ImmutableDataFrame2RegressionKnetTransformer(
        featurenames,
        dffeaturecontrasts,
        labelnames;
        transposefeatures = true,
        transposelabels = true,
        )
    knetestimator = MutableKnetjlNeuralNetworkEstimator(
        ;
        name = name,
        predict = predict,
        loss = loss,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        batchsize = batchsize,
        modelweights = modelweights,
        isclassificationmodel = false,
        isregressionmodel = true,
        printlosseverynepochs = printlosseverynepochs,
        maxepochs = maxepochs,
        )
    predpackager = ImmutablePackageMultiLabelPredictionTransformer(
        [singlelabelname,],
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            knetestimator,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelknetregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        dffeaturecontrasts::AbstractContrastsObject;
        package::Symbol = :none,
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        batchsize::Integer = 0,
        modelweights::AbstractArray = [],
        printlosseverynepochs::Integer = 0,
        maxepochs::Integer = 0,
        )
    if package == :Knetjl
        result = _singlelabelknetregression_Knet(
            featurenames,
            singlelabelname,
            dffeaturecontrasts;
            name = name,
            predict = predict,
            loss = loss,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            batchsize = batchsize,
            modelweights = modelweights,
            printlosseverynepochs = printlosseverynepochs,
            maxepochs = maxepochs,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const knetregression = singlelabelknetregression
