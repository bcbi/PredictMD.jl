import StatsModels

struct FeatureContrastsNotYetGenerated <: AbstractNonExistentFeatureContrasts
end

struct FitNotYetRunUnderlyingObject <: AbstractNonExistentUnderlyingObject
end

struct FitFailedUnderlyingObject <: AbstractNonExistentUnderlyingObject
end

"""
"""
mutable struct GLMModel <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    formula::T4 where T4 <: Any
    family::T5 where T5 <: Any
    link::T6 where T6 <: Any

    # parameters (learned from data):
    underlyingglm::T7 where T7 <: Any
end

"""
"""
mutable struct KnetModel <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    # hyperparameters (not learned from data):
    predict_function_source::T4 where T4 <: AbstractString
    loss_function_source::T5 where T5 <: AbstractString
    predict_function::T6 where T6 <: Any
    loss_function::T7 where T7 <: Any
    losshyperparameters::T8 where T8 <: AbstractDict
    optimizationalgorithm::T9 where T9 <: Symbol
    optimizerhyperparameters::T10 where T10 <: AbstractDict
    minibatchsize::T11 where T11 <: Integer
    maxepochs::T12 where T12 <: Integer
    printlosseverynepochs::T13 where T13 <: Integer

    # parameters (learned from data):
    modelweights::T14 where T14 <: AbstractArray
    modelweightoptimizers::T15 where T15 <: Any

    # learning state
    history::T16 where T16 <: Any
end

"""
"""
mutable struct SimplePipeline{S<:AbstractString, T<:AbstractVector} <: AbstractPipeline
    name::S
    objectsvector::T
end

struct PGFPlotsXPlot <: AbstractPlot
    underlying_object::T where T <: Any
end

"""
"""
struct ImmutablePackageMultiLabelPredictionTransformer <: AbstractEstimator
    label_names::T1 where T1 <: AbstractVector{Symbol}
end

"""
"""
struct ImmutablePackageSingleLabelPredictionTransformer <: AbstractEstimator
    single_label_name::T1 where T1 <: Symbol
end

"""
"""
struct ImmutablePackageSingleLabelPredictProbaTransformer <:
        AbstractEstimator
    single_label_name::T1 where T1 <: Symbol
end

"""
"""
struct ImmutablePredictionsSingleLabelInt2StringTransformer <:
        AbstractEstimator
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

"""
"""
struct ImmutablePredictProbaSingleLabelInt2StringTransformer <:
        AbstractEstimator
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

"""
"""
struct DataFrameFeatureContrasts <: AbstractFeatureContrasts
    columns::T1 where T1 <: AbstractVector{Symbol}
    num_df_columns::T2 where T2 <: Integer
    schema_without_intercept::T3 where T3 <: StatsModels.Schema
    formula_without_intercept::T4 where T4 <: StatsModels.AbstractTerm
    num_array_columns_without_intercept::T5 where T5 <: Integer
    schema_with_intercept::T6 where T6 <: StatsModels.Schema
    formula_with_intercept::T7 where T7 <: StatsModels.AbstractTerm
    num_array_columns_with_intercept::T8 where T8 <: Integer
end

"""
"""
mutable struct MutableDataFrame2DecisionTreeTransformer <: AbstractEstimator
    feature_names::T1 where T1 <: AbstractVector
    single_label_name::T2 where T2 <: Symbol
    levels::T3 where T3 <: AbstractVector
    dffeaturecontrasts::T4 where T4 <: AbstractFeatureContrasts
end

"""
"""
struct ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer <:
        AbstractEstimator
    label::T1 where T1 <: Symbol
    positive_class::T2 where T2 <: AbstractString
end

"""
"""
mutable struct MutableDataFrame2ClassificationKnetTransformer <:
        AbstractEstimator
    feature_names::T1 where T1 <: AbstractVector
    label_names::T2 where T2 <: AbstractVector{Symbol}
    label_levels::T3 where T3 <: AbstractDict
    index::T4 where T4 <: Integer
    transposefeatures::T5 where T5 <: Bool
    transposelabels::T6 where T6 <: Bool
    dffeaturecontrasts::T7 where T7 <: AbstractFeatureContrasts
end

"""
"""
mutable struct MutableDataFrame2RegressionKnetTransformer <:
        AbstractEstimator
    feature_names::T1 where T1 <: AbstractVector
    label_names::T2 where T2 <: AbstractVector{Symbol}
    transposefeatures::T3 where T3 <: Bool
    transposelabels::T4 where T4 <: Bool
    dffeaturecontrasts::T5 where T5 <: AbstractFeatureContrasts
    function MutableDataFrame2RegressionKnetTransformer(
            feature_names::AbstractVector,
            label_names::AbstractVector{Symbol};
            transposefeatures::Bool = true,
            transposelabels::Bool = false,
            )
        result = new(
            feature_names,
            label_names,
            transposefeatures,
            transposelabels,
            )
        return result
    end
end

"""
"""
struct ImmutableFeatureArrayTransposerTransformer <: AbstractEstimator
end

"""
"""
mutable struct LIBSVMModel <: AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    levels::T4 where T4 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T5 where T5 <: AbstractDict

    # parameters (learned from data):
    underlyingsvm::T6 where T6 <: Any
end

"""
"""
mutable struct DecisionTreeModel <:
        AbstractEstimator
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    single_label_name::T4 where T4 <: Symbol
    levels::T5 where T5 <: AbstractVector

    # hyperparameters (not learned from data):
    hyperparameters::T6 where T6 <: AbstractDict

    # parameters (learned from data):
    underlyingrandomforest::T7 where T7 <: Any
end

"""
"""
struct CrossValidation{T}
    leavein::Vector{CrossValidation{T}}
    leaveout::Vector{Vector{T}}
end
