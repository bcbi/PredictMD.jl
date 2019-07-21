import NumericalIntegration

"""
    trapz(x, y)

Compute the area under the curve of 2-dimensional points (x, y) using
the trapezoidal method.
"""
function trapz end

trapz(x, y) = trapz(promote(x, y)...)

function trapz(
        x::AbstractVector{T},
        y::AbstractVector{T},
        )::T where T
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    if !all(x .== sort(x; rev = false))
        error("x needs to be sorted in ascending order")
    end
    twoI::T = zero(T)
    for k = 2:length(x)
        twoI += ( y[k] + y[k-1] ) * ( x[k] - x[k-1] )
    end
    I_verify::T = NumericalIntegration.integrate(
        x,
        y,
        NumericalIntegration.Trapezoidal(),
        )
    @assert isapprox(twoI/2, I_verify; atol=0.00000001)
    return I_verify
end
