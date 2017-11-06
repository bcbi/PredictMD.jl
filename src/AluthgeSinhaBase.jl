module AluthgeSinhaBase

# abstract types to export:
export AbstractDataset,
    AbstractTabularDataset,
    AbstractHoldoutTabularDataset

# concrete types to export:
export HoldoutTabularDataset

# functions to export:

include("abstracttypes.jl")
include("fakedata.jl")
include("formulas.jl")
include("labelcoding.jl")
include("tabulardatasets.jl")
include("util.jl")
include("version.jl")

end # end module AluthgeSinhaBase
