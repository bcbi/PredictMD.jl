import PredictMDAPI

PredictMDAPI.get_history(::Fittable; kwargs...)::Nothing = nothing

PredictMDAPI.get_underlying(::Fittable; kwargs...)::Nothing = nothing

PredictMDAPI.parse_functions!(::Fittable)::Nothing = nothing

PredictMDAPI.set_feature_contrasts!(::Fittable,
                                    ::AbstractFeatureContrasts)::Nothing = nothing

PredictMDAPI.set_max_epochs!(::Fittable,::Integer)::Nothing = nothing
