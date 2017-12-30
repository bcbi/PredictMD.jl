# include("../examples/breastcancerbiopsy.jl")

import PGFPlots

tikzpic = PGFPlots.plot([1,2,3], [1,4,9])

asb.open(tikzpic)
