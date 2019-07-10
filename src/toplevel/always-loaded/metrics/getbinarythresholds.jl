import StatsBase

"""
"""
function get_binary_thresholds(
        yscore::AbstractVector{<:Real};
        additionalthreshold::AbstractFloat = 0.5,
        )
    if !all(0 .<= yscore .<= 1)
        error("not all scores are in [0,1]")
    end
    result = sort(
        unique(
            vcat(
                0 - eps(),
                0,
                0 + eps(),
                1 - eps(),
                1,
                1 + eps(),
                additionalthreshold,
                unique(yscore),
                )
            );
        rev = false,
        )
    return result
end

