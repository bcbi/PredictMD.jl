##### Beginning of file

module Backends # begin submodule PredictMD.Backends

abstract type AbstractBackend end

struct ClassImbalance <: AbstractBackend
end

struct DecisionTree <: AbstractBackend
end

struct Documenter <: AbstractBackend
end

struct Flux <: AbstractBackend
end

struct GLM <: AbstractBackend
end

struct Knet <: AbstractBackend
end

struct LIBSVM <: AbstractBackend
end

struct PGFPlots <: AbstractBackend
end

struct PGFPlotsX <: AbstractBackend
end

end # end submodule PredictMD.Backends

##### End of file
