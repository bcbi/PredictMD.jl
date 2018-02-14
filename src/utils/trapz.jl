import NumericalIntegration

function _aluthgetrapz(
        x::AbstractVector,
        y::AbstractVector,
        )
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    N = length(x)
    if !all(x .== sort(x; rev = false))
        error("x needs to be sorted in ascending order")
    end
    twoI = 0
    for k = 2:N
        twoI += ( y[k] + y[k-1] ) * ( x[k] - x[k-1] )
    end
    I = twoI/2
    return I
end

function trapz(
        x::AbstractVector,
        y::AbstractVector,
        )
    result_aluthgetrapz = _aluthgetrapz(
        x,
        y,
        )
    result_numericalintegration = NumericalIntegration.integrate(
        x,
        y,
        NumericalIntegration.Trapezoidal(),
        )
    if !isapprox(result_aluthgetrapz, result_numericalintegration; atol=0.00000001)
        msg = string(
            "result_aluthgetrapz!=result_numericalintegration. ",
            "result_aluthgetrapz=$(result_aluthgetrapz). ",
            "result_numericalintegration=$(result_numericalintegration)",
            )
        error(msg)
    end
    return result_aluthgetrapz
end
