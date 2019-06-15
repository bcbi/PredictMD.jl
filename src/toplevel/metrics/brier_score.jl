"""
    binary_brier_score(ytrue, yscore)

Computes the binary formulation of the Brier score, defined as:

```math
\\frac{1}{N}\\sum\\limits _{t=1}^{N}(f_t-o_t)^2 \\,\\!
```

Lower values are better. Best value is 0.
"""
function binary_brier_score(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:AbstractFloat},
        )
    if length(ytrue) != length(yscore)
        error("length(ytrue) != length(yscore)")
    end
    if length(ytrue) == 0
        error("length(ytrue) == 0")
    end
    result = mean_square_error(ytrue, yscore)
    return result
end

