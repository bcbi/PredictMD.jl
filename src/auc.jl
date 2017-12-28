# import Interpolations
# import QuadGK
#
# function areaundercurveinterpolated(
#         ;
#         x::AbstractVector{T} = [],
#         y::AbstractVector{T} = [],
#         sort::Bool = true,
#         rev::Bool = false,
#         ) where T <: Real
#     if length(x) != length(y)
#         error("x and y must have the same length")
#     end
#     if length(x) < 2
#         error("x and y must each have length >=2 ")
#     end
#     #
#     if sort
#         sortingpermutation = sortperm(x; rev = rev)
#         x = x[sortingpermutation]
#         y = y[sortingpermutation]
#     end
#     #
#     x_min = minimum(x)
#     x_max = maximum(x)
#     itp = Interpolations.interpolate(
#         (x,),
#         y,
#         Interpolations.Gridded(Interpolations.Linear()),
#         )
#     f(t) = itp[t]
#     I, E = QuadGK.quadgk(f, x_min, x_max)
#     return I
# end
#
# function trapz(
#         ;
#         x::AbstractVector{T} = [],
#         y::AbstractVector{T} = [],
#         sort::Bool = true,
#         rev::Bool = false,
#         ) where T <: Real
#     if length(x) != length(y)
#         error("x and y must have the same length")
#     end
#     if length(x) < 2
#         error("x and y must each have length >=2 ")
#     end
#     #
#     if sort
#         sortingpermutation = sortperm(x; rev = rev)
#         x = x[sortingpermutation]
#         y = y[sortingpermutation]
#     end
#     #
#     N = length(x) - 1
#     #
#     the_sum = 0
#     for n = 1:N
#         the_sum += (x[n+1] - x[n]) * (y[n] + y[n+1])
#     end
#     I = the_sum/2
#     return I
# end
