import Knet
import StatsFuns
import ValueHistories

function _emptyfunction()
end

mutable struct MutableKnetEstimator <: AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    # hyperparameters (not learned from data):
    predict::T4 where T4 <: Function
    loss::T5 where T5 <: Function
    losshyperparameters::T6 where T6 <: Associative
    optimizationalgorithm::T7 where T7 <: Symbol
    optimizerhyperparameters::T8 where T8 <: Associative
    batchsize::T9 where T <: Integer
    maxepochs::T10 where T <: Integer

    # parameters (learned from data):
    modelweights::T11 where T <: AbstractArray
    modelweightoptimizers::T12 where T

    # learning state
    lastepoch::T13 where T13 <: Integer
    lastiteration::T14 where T14 <: Integer
    valuehistories::T15 where T15 <: ValueHistories.MultivalueHistory

    function MutableKnetEstimator(
            ;
            name::AbstractString = "",
            predict::Function = _emptyfunction,
            loss::Function =_emptyfunction,
            losshyperparameters::Associative = Dict(),
            optimizationalgorithm::Symbol = :nothing,
            optimizerhyperparameters::Associative = Dict(),
            batchsize::Integer = 0,
            modelweights::AbstractArray = [],
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
            )
        return result
    end
end

function underlying(x::AbstractASBKnetKnetSingleLabelClassifier)
    result = (predictfunction, modelweightsmodelweights)
    return result
end

function valuehistories(x::AbstractASBKnetKnetSingleLabelClassifier)
    result = x.valuehistories
    return result
end

function fit!(
        estimator::AbstractASBKnetKnetSingleLabelClassifier,
        featuresarray::AbstractArray,
        labelsarray::AbstractVector;
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        io::IO = Base.STDOUT,
        )
    if !(maxepochs > 0)
        error("maxepochs must be >0")
    end
    featuresarray = Cfloat.(featuresarray)
    labelsarray = Int.(labelsarray)
    trainingdata = Knet.minibatch(
        featuresarray,
        labelsarray,
        estimator.batchsize,
        )
    lossgradient = Knet.grad(
        estimator.loss,
        2,
        )
    info("Starting to train Knet model...")
    while estimator.lastepoch < maxepochs
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
        if (printlosseverynepochs > 0) &&
                ( (estimator.lastepoch % printlosseverynepochs) == 0 )
            info(
                io,
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
    info("Finished training Knet model.")
    return estimator
end

function predict_proba(
        estimator::AbstractASBKnetKnetSingleLabelClassifier,
        featuresarray::AbstractArray,
        )
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
end

function singlelabelknetclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        maxepochs::Integer = 0,
        batchsize::Integer = 0,
        modelweights::AbstractArray = [],
        )
    labelnames = [singlelabelname]
    labellevels = Dict()
    labellevels[singlelabelname] = singlelabellevels
    dftransformer = DataFrame2KnetTransformer(
        featurenames,
        labelnames,
        labellevels,
        1,
        df;
        transposefeatures = true,
        )
    knetestimator = ASBKnetKnetSingleLabelClassifier(
        ;
        name = name,
        predict = predict,
        loss = loss,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        batchsize = batchsize,
        modelweights = modelweights,
        )
    predprobafixer = PredictProbaSingleLabelInt2StringTransformer(
        1,
        singlelabellevels
        )
    probapackager = PackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    finalpipeline = SimplePipeline(
        [
            dftransformer,
            knetestimator,
            predprobafixer,
            probapackager,
            ];
        name = name,
        underlyingobjectindex = 2,
        valuehistoriesobjectindex = 2,
        )
    return finalpipeline
end

const knetclassifier = singlelabelknetclassifier
