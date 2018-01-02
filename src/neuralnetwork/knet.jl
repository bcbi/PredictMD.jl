import Knet
import StatsFuns
import ValueHistories

abstract type AbstractASBKnetjlKnetClassifier <:
        AbstractClassifier
end

abstract type AbstractASBKnetjlKnetSingleLabelClassifier <:
        AbstractClassifier
end

abstract type AbstractASBKnetjlKnetRegression <:
        AbstractRegression
end

function _emptyfunction()
end

mutable struct ASBKnetjlKnetSingleLabelClassifier <:
        AbstractASBKnetjlKnetSingleLabelClassifier
    name::T1 where T1 <: AbstractString

    # hyperparameters (not learned from data):
    predict::T2 where T2 <: Function
    loss::T3 where T3 <: Function
    losshyperparameters::T4 where T4 <: Associative
    optimizationalgorithm::T5 where T5 <: Symbol
    optimizerhyperparameters::T6 where T6 <: Associative
    batchsize::T7 where T7 <: Integer

    # parameters (learned from data):
    modelweights::T8 where T8 <: AbstractArray
    modelweightoptimizers::T9 where T9 <: Any

    # learning state
    lastepoch::T10 where T10 <: Integer
    lastiteration::T11 where T11 <: Integer
    multivaluehistory::T12 where T12 <: ValueHistories.MultivalueHistory

    function ASBKnetjlKnetSingleLabelClassifier(
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
        if predict == _emptyfunction
            msg = string(
                "you need to specify a prediction function of the form ",
                "predict = predict(modelweights, x; training)"
                )
            error(msg)
        end
        if loss == _emptyfunction
            msg = string(
                "you need to specify a loss function of the form ",
                "loss = loss(predict, modelweights, x, ygold)"
                )
            error(msg)
        end
        if !(batchsize > 0)
            error("batchsize must be >0")
        end
        if length(modelweights) == 0
            error("modelweights must be non-empty")
        end
        optimizersymbol2type = Dict()
        optimizersymbol2type[:Sgd] = Knet.Sgd
        optimizersymbol2type[:Momentum] = Knet.Momentum
        optimizersymbol2type[:Nesterov] = Knet.Nesterov
        optimizersymbol2type[:Rmsprop] = Knet.Rmsprop
        optimizersymbol2type[:Adagrad] = Knet.Adagrad
        optimizersymbol2type[:Adadelta] = Knet.Adadelta
        optimizersymbol2type[:Adam] = Knet.Adam
        if haskey(optimizersymbol2type, optimizationalgorithm)
            modelweightoptimizers = Knet.optimizers(
                modelweights,
                optimizersymbol2type[optimizationalgorithm];
                optimizerhyperparameters...
                )
        else
            msg = string(
                "optimizationalgorithm must be one of the following: ",
                collect(keys(optimizersymbol2type)),
                )
            error(msg)
        end

        lastepoch = 0
        lastiteration = 0
        multivaluehistory = ValueHistories.MVHistory()
        result = new(
            name,
            predict,
            loss,
            losshyperparameters,
            optimizationalgorithm,
            optimizerhyperparameters,
            batchsize,
            modelweights,
            modelweightoptimizers,
            lastepoch,
            lastiteration,
            multivaluehistory,
            )
        return result
    end
end

function underlying(x::AbstractASBKnetjlKnetSingleLabelClassifier)
    result = (predictfunction, modelweightsmodelweights)
    return result
end

function valuehistories(x::AbstractASBKnetjlKnetSingleLabelClassifier)
    result = x.multivaluehistory
    return result
end

function fit!(
        estimator::AbstractASBKnetjlKnetSingleLabelClassifier,
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
                estimator.multivaluehistory,
                :lossatiteration,
                estimator.lastiteration,
                currentiterationloss,
                )
        end # end for
        estimator.lastepoch += 1
        ValueHistories.push!(
            estimator.multivaluehistory,
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
            estimator.multivaluehistory,
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
        estimator::AbstractASBKnetjlKnetSingleLabelClassifier,
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
    dftransformer = DataFrame2KnetjlTransformer(
        featurenames,
        labelnames,
        labellevels,
        1,
        df;
        transposefeatures = true,
        )
    knetestimator = ASBKnetjlKnetSingleLabelClassifier(
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
            probapackager
            ];
        name = name,
        underlyingobjectindex = 2,
        valuehistoriesobjectindex = 2,
        )
    return finalpipeline
end

const knetclassifier = singlelabelknetclassifier
