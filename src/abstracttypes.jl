abstract type AbstractDataset{T}
end

abstract type AbstractTabularDataset{T} <: AbstractDataset{T}
end

abstract type AbstractHoldoutTabularDataset{T} <: AbstractTabularDataset{T}
end

abstract type AbstractKFoldTabularDataset{T} <: AbstractTabularDataset{T}
end

abstract type AbstractModelly
end

abstract type AbstractSingleModel{D} <: AbstractModelly
end

abstract type AbstractEnsemble{M} <: AbstractModelly
end

abstract type AbstractClassifier{D} <: AbstractSingleModel{D}
end

abstract type AbstractSingleLabelClassifier{D} <: AbstractClassifier{D}
end

abstract type AbstractSingleLabelBinaryClassifier{D} <:
    AbstractSingleLabelClassifier{D}
end

const AbstractBinaryClassifier = AbstractSingleLabelBinaryClassifier

abstract type AbstractRegression{D} <: AbstractSingleModel{D}
end

abstract type AbstractSingleLabelRegression{D} <: AbstractRegression{D}
end

abstract type AbstractModelPerformance{M}
end

abstract type AbstractModelPerformanceDataForPlots{M}
end

abstract type AbstractModelPerformancePlots{M}
end

function numtraining(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numtraining]
end
function numvalidation(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numvalidation]
end
function numtesting(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numtesting]
end

hastraining(m::AbstractSingleLabelBinaryClassifier) = numtraining(m) > 0
hasvalidation(m::AbstractSingleLabelBinaryClassifier) = numvalidation(m) > 0
hastesting(m::AbstractSingleLabelBinaryClassifier) = numtesting(m) > 0
