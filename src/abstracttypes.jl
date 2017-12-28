# abstract type AbstractDataset{T}
# end
#
# abstract type AbstractTabularDataset{T} <: AbstractDataset{T}
# end
#
# abstract type AbstractHoldoutTabularDataset{T} <: AbstractTabularDataset{T}
# end
#
# abstract type AbstractKFoldTabularDataset{T} <: AbstractTabularDataset{T}
# end
#
# abstract type AbstractModelly
# end
#
# abstract type AbstractSingleModel{D} <: AbstractModelly
# end
#
# abstract type AbstractEnsemble{M} <: AbstractModelly
# end
#
# abstract type AbstractClassifier{D} <: AbstractSingleModel{D}
# end
#
# abstract type AbstractSingleLabelClassifier{D} <: AbstractClassifier{D}
# end
#
# abstract type AbstractSingleLabelBinaryClassifier{D} <:
#     AbstractSingleLabelClassifier{D}
# end
#
# const AbstractBinaryClassifier = AbstractSingleLabelBinaryClassifier
#
# abstract type AbstractRegression{D} <: AbstractSingleModel{D}
# end
#
# abstract type AbstractSingleLabelRegression{D} <: AbstractRegression{D}
# end
#
# abstract type AbstractModelPerformance{M}
# end
#
# numtraining(m::AbstractSingleLabelBinaryClassifier) = m.blobs[:numtraining]
# numvalidation(m::AbstractSingleLabelBinaryClassifier) = m.blobs[:numvalidation]
#
# numtesting(m::AbstractSingleLabelBinaryClassifier) = m.blobs[:numtesting]
#
# hastraining(m::AbstractSingleLabelBinaryClassifier) = numtraining(m) > 0
# hasvalidation(m::AbstractSingleLabelBinaryClassifier) = numvalidation(m) > 0
# hastesting(m::AbstractSingleLabelBinaryClassifier) = numtesting(m) > 0
#
# dataname(m::AbstractSingleLabelBinaryClassifier) = m.blobs[:data_name]
# modelname(m::AbstractSingleLabelBinaryClassifier) = m.blobs[:model_name]
