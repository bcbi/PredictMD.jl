import DataFrames
import StatsBase

function train_test_split(
        featuresdf::T2,
        labelsdf::T3;
        training::T4 = 0.0,
        testing::T5 = 0.0,
        ) where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame where
        T4 <: Real where
        T5 <: Real
    result = train_test_split(
        Base.GLOBAL_RNG,
        featuresdf,
        labelsdf,
        training = training,
        testing = testing,
        )
    return result
end

function train_test_split(
        rng::T1,
        featuresdf::T2,
        labelsdf::T3;
        training::T4 = 0.0,
        testing::T5 = 0.0,
        ) where
        T1 <: AbstractRNG where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame where
        T4 <: Real where
        T5 <: Real
    if !(training + testing == 1.0)
        error("training + testing must equal 1.0")
    end
    if !(0 <= training <= 1)
        error("training must be >=0 and <=1")
    end
    if !(0 <= testing <= 1)
        error("testing must be >=0 and <=1")
    end
    if size(featuresdf, 1) != size(labelsdf, 1)
        error("featuresdf and labelsdf do not have the same number of rows")
    end
    numrows = size(featuresdf, 1)
    numtraining = round(Int, training * numrows)
    numtesting = numrows - numtraining
    @assert(numtraining + numtesting == numrows)
    @assert( isapprox(numtraining/numrows, training; atol=0.1) )
    @assert( isapprox(numtesting/numrows, testing; atol=0.1) )
    allrows = convert(Array, 1:numrows)
    trainingrows = StatsBase.sample(
        rng,
        allrows,
        numtraining;
        replace = false,
        )
    testingrows = setdiff(allrows, trainingrows)
    @assert(typeof(trainingrows) <: AbstractVector)
    @assert(typeof(testingrows) <: AbstractVector)
    @assert(length(trainingrows) == numtraining)
    @assert(length(testingrows) == numtesting)
    @assert(
        all(
            allrows .== sort(vcat(trainingrows, testingrows))
            )
        )
    trainfeatdf = featuresdf[trainingrows, :]
    testfeatdf = featuresdf[testingrows, :]
    trainlabdf = labelsdf[trainingrows, :]
    testlabdf = labelsdf[testingrows, :]
    return trainfeatdf,testfeatdf, trainlabdf,testlabdf
end
