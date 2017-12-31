import Knet
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

function _knet_defaultpredictfunction_donotuse(w,x)
    return x
end

function _knet_defaultlossfunction_donotuse(w,x,ygold)
    return 0
end

mutable struct ASBKnetjlKnetSingleLabelClassifier <:
        AbstractASBKnetjlKnetSingleLabelClassifier
    name::T1 where T1 <: AbstractString

    # hyperparameters (not learned from data):
    predict::T2 where T2 <: Function
    loss::T3 where T3 <: Function
    optimizers::T4 where T4
    maxepochs::T5 where T5 <: Integer
    batchsize::T6 where T6 <: Integer

    # parameters (learned from data):
    model::T7 where T7 <: AbstractArray

    # learning state
    lastepoch::T8 where T8 <: Integer
    multivaluehistory::T9 where T9 <: ValueHistories.MultivalueHistory

    function ASBKnetjlKnetSingleLabelClassifier(
            ;
            name::AbstractString = "",
            predict::Function = _knet_defaultpredictfunction_donotuse,
            loss::Function = _knet_defaultlossfunction_donotuse,
            optimizers = nothing,
            maxepochs::Integer = 0,
            batchsize::Integer = 0,
            model::AbstractArray = [],
            )
        if predict == _knet_defaultpredictfunction_donotuse
            error("you need to specify predict")
        end
        if loss == _knet_defaultlossfunction_donotuse
            error("you need to specify loss")
        end
        if length(model) == 0
            error("model must be non-empty")
        end
        if optimizers == nothing
            optimizers = Knet.optimizers(model, Knet.Adam)
        end
        if !(maxepochs > 0)
            error("maxepochs must be >0")
        end
        if !(batchsize > 0)
            error("batchsize must be >0")
        end
        if ndims(model) != ndims(optimizers)
            error("ndims(model) != ndims(optimizers)")
        end
        if size(model) != size(optimizers)
            error("size(model) != size(optimizers)")
        end
        lastepoch = 0
        multivaluehistory = ValueHistories.MVHistory()
        result = new(
            name,
            predict,
            loss,
            optimizers,
            maxepochs,
            batchsize,
            model,
            lastepoch,
            multivaluehistory,
            )
        return result
    end
end

function underlying(x::AbstractASBKnetjlKnetSingleLabelClassifier)
    result = (predictfunction, modelmodel)
    return result
end

function valuehistories(x::AbstractASBKnetjlKnetSingleLabelClassifier)
    result = x.multivaluehistory
    return result
end

function fit!(
        estimator::AbstractASBKnetjlKnetSingleLabelClassifier,
        featuresarray::AbstractArray,
        labelsarray::AbstractVector,
        )
    trainingdata = Knet.minibatch(
        featuresarray,
        labelsarray,
        estimator.batchsize,
        )
    lossgradient = Knet.grad(estimator.loss)
    while estimator.lastepoch < estimator.maxepochs
        for (x,y) in trainingdata
            grads = lossgradient(
                estimator.model,
                x,
                y,)
            Knet.update!(
                estimator.model,
                grads,
                estimators.optimizers,
                )
        end # end for
        estimator.lastepoch += 1
        currentloss = estimator.loss(
            estimator.model,
            featuresarray,
            labelsarray,
            )
        if estimator.lastepoch == 1
            info(
                string(
                    "Loss after 1 epoch: $(currentloss)"
                    )
                )
        else
            info(
                string(
                    "Loss after $(estimator.lastepoch) epochs: $(currentloss)"
                    )
                )
        end # end if
        ValueHistories.push!(
            estimator.multivaluehistory,
            :loss,
            estimator.lastepoch,
            currentloss,
            )
    end # end while
    return estimator
end

function predict_proba(
        estimator::AbstractASBKnetjlKnetSingleLabelClassifier,
        featuresarray::AbstractArray,
        )
    output = estimator.predict(
        estimator.model,
        featuresarray,
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

# (
#         ;

#         )

function singlelabelknetclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector,
        df::DataFrames.AbstractDataFrame;
        name::AbstractString = "",
        predict::Function = _knet_defaultpredictfunction_donotuse,
        loss::Function = _knet_defaultlossfunction_donotuse,
        optimizers = nothing,
        maxepochs::Integer = 0,
        batchsize::Integer = 0,
        model::AbstractArray = [],
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
        optimizers = optimizers,
        maxepochs = maxepochs,
        batchsize = batchsize,
        model = model,
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
        )
    return finalpipeline
end

const knetclassifier = singlelabelknetclassifier
