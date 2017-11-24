import Interpolations
import QuadGK

function areaundercurveinterpolated(
        x::AbstractVector{T},
        y::AbstractVector{T},
        ) where T <: Real
    if length(x) != length(y)
        error("x and y must have the same length")
    end
    if length(x) < 2
        error("x and y must each have length >=2 ")
    end
    #
    sortingpermutation = sortperm(x)
    sortedx = x[sortingpermutation]
    sortedy = y[sortingpermutation]
    #
    x_min = minimum(sortedx)
    x_max = maximum(sortedx)
    itp = Interpolations.interpolate(
        (sortedx,),
        sortedy,
        Interpolations.Gridded(Interpolations.Linear()),
        )
    f(t) = itp[t]
    I, E = QuadGK.quadgk(f, x_min, x_max)
    return I
end

function trapz(
        x::AbstractVector{T},
        y::AbstractVector{T},
        ) where T <: Real
    if length(x) != length(y)
        error("x and y must have the same length")
    end
    if length(x) < 2
        error("x and y must each have length >=2 ")
    end
    #
    sortingpermutation = sortperm(x)
    sortedx = x[sortingpermutation]
    sortedy = y[sortingpermutation]
    #
    N = length(x) - 1
    #
    sum = 0
    for n = 1:N
        sum += (x[n+1] - x[n]) * (y[n] + y[n+1])
    end
    I = sum/2
    return I
end
