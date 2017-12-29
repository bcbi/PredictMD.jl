import StatsBase

function getbinarythresholds(
        yscore::StatsBase.RealVector;
        additionalthreshold::Real = 0.5,
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
            )
        )
    @assert(typeof(result) <: AbstractVector)
    return result
end
