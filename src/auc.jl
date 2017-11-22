import Interpolations
import QuadGK

function areaundercurve(
        x::AbstractVector{T},
        y::AbstractVector{T},
        ) where T <: Real
    x_min = minimum(x)
    x_max = maximum(x)
    itp = Interpolations.interpolate(
        (x,),
        y,
        Interpolations.Gridded(Interpolations.Linear()),
        )
    f(t) = itp[t]
    I, E = QuadGK.quadgk(f, x_min, x_max)
    I_correcttype = convert(T, I)
    return I_correcttype
end
