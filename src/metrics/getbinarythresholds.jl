import StatsBase

function getbinarythresholds(
        yscore::T2;
        additionalthreshold::T3 = 0.5,
        ) where
        T2 <: StatsBase.RealVector where
        T3 <: Real
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
