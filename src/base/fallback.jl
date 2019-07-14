import PredictMDAPI

PredictMDAPI.get_history(::AbstractFittable; kwargs...)::Nothing = nothing

PredictMDAPI.get_underlying(::AbstractFittable; kwargs...)::Nothing = nothing

PredictMDAPI.parse_functions!(::AbstractFittable)::Nothing = nothing

PredictMDAPI.set_feature_contrasts!(::AbstractFittable,
                                    ::AbstractFeatureContrasts)::Nothing = nothing

PredictMDAPI.set_max_epochs!(::AbstractFittable,::Integer)::Nothing = nothing
