import NumericalIntegration

"""
    trapz(x, y)

Compute the area under the curve of 2-dimensional points (x, y) using the
trapezoidal method.
"""
function trapz(
        x::AbstractVector,
        y::AbstractVector,
        )
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    if !all(x .== sort(x; rev = false))
        error("x needs to be sorted in ascending order")
    end
    twoI = 0
    for k = 2:length(x)
        twoI += ( y[k] + y[k-1] ) * ( x[k] - x[k-1] )
    end
    I = twoI/2
    I_verify = NumericalIntegration.integrate(
        x,
        y,
        NumericalIntegration.Trapezoidal(),
        )
    if !isapprox(I, I_verify; atol=0.00000001)
        error("Was not able to accurately compute trapezoidal integration.")
    end
    return I
end

