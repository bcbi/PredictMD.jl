include("metrics/auprc.jl")
include("metrics/aurocc.jl")
include("metrics/averageprecisionscore.jl")
include("metrics/binaryclassificationmetrics.jl")
include("metrics/getbinarythresholds.jl")
include("metrics/prcurve.jl")
include("metrics/roccurve.jl")
include("metrics/rocnumsmetrics.jl")

# function numtotal(
#         rocnums::MLBase.ROCNums
#         )
#     @assert(rocnums.p == rocnums.tp + rocnums.fn)
#     @assert(rocnums.n == rocnums.tn + rocnums.fp)
#     return rocnums.p + rocnums.n
# end
#
# function accuracy_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if numtotal(rocnums) == 0
#         return value
#     else
#         return ( rocnums.tp + rocnums.tn )/( numtotal(rocnums) )
#     end
# end
#
# function true_positive_rate_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.p == 0
#         return value
#     else
#         return MLBase.true_positive_rate(rocnums)
#     end
# end
#
# sensitivity_nanfixed(varargs...) = true_positive_rate_nanfixed(varargs...)
#
# function true_negative_rate_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.n == 0
#         return value
#     else
#         return MLBase.true_negative_rate(rocnums)
#     end
# end
#
# specificity_nanfixed(varargs...) = true_negative_rate_nanfixed(varargs...)
#
# function false_positive_rate_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.n == 0
#         return value
#     else
#         return MLBase.false_positive_rate(rocnums)
#     end
# end
#
# function false_negative_rate_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.p == 0
#         return value
#     else
#         return MLBase.false_negative_rate(rocnums)
#     end
# end
#
# function precision_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 1.0,
#         )
#     if rocnums.tp + rocnums.fp == 0
#         return value
#     else
#         return MLBase.precision(rocnums)
#     end
# end
#
# recall_nanfixed(varargs...) = true_positive_rate_nanfixed(varargs...)
#
# function positive_predictive_value_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.tp + rocnums.fp == 0
#         return value
#     else
#         return ( rocnums.tp )/( rocnums.tp + rocnums.fp )
#     end
# end
#
# function negative_predictive_value_nanfixed(
#         rocnums::MLBase.ROCNums,
#         value::AbstractFloat = 0.0,
#         )
#     if rocnums.tn + rocnums.fn == 0
#         return value
#     else
#         return ( rocnums.tn )/( rocnums.tn + rocnums.fn )
#     end
# end
#
# function fbetascore(
#         precision::Real,
#         recall::Real,
#         beta::Real,
#         )
#     if !(0 <= precision <= 1)
#         error("precision must be >=0 and <=1")
#     end
#     if !(0 <= recall <= 1)
#         error("recall must be >=0 and <=1")
#     end
#     if !(beta > 0)
#         error("beta must be >0")
#     end
#     return (1+beta^2)*(precision*recall)/((beta^2*precision)+(recall))
# end
#
# function fbetascore(
#         precisions_list::StatsBase.RealVector,
#         recalls_list::StatsBase.RealVector,
#         beta::Real,
#         )
#     if length(precisions_list) != length(recalls_list)
#         error("precisions_list and recalls_list must have the same length")
#     end
#     n = length(precisions_list)
#     return [fbetascore(precisions_list[i],recalls_list[i],beta) for i = 1:n]
# end
