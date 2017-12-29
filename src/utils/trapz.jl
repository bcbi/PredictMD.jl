function trapz(
        x::T1,
        y::T2,
        ) where
        T1 <: AbstractVector where
        T2 <: AbstractVector
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    N = length(x)
    if !all(x .== sort(x))
        error("x needs to be sorted in ascending order")
    end
    twoI = 0
    for k = 2:N
        twoI += ( y[k] + y[k-1] ) * ( x[k] - x[k-1] )
    end
    I = twoI/2
    return I
end
