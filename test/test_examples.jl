# include("../examples/breastcancerbiopsy.jl")

import PGFPlots

tikzpic = PPGFPlots.plot([1,2,3], [1,4,9])

asb.open(tikzpic)
