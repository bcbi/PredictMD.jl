ENV["linearreg_filename"] = string(tempname(), "_linearreg.jld2")
ENV["randomforestreg_filename"] = string(tempname(), "_randomforestreg.jld2")
ENV["epsilonsvr_svmreg_filename"] = string(tempname(), "_epsilonsvr_svmreg.jld2")
ENV["nusvr_svmreg_filename"] = string(tempname(), "_nusvr_svmreg.jld2")
ENV["knetmlpreg_filename"] = string(tempname(), "_knetmlpreg.jld2")

Base.Test.@test(!isfile(ENV["linearreg_filename"]))
Base.Test.@test(!isfile(ENV["randomforestreg_filename"]))
Base.Test.@test(!isfile(ENV["epsilonsvr_svmreg_filename"]))
Base.Test.@test(!isfile(ENV["nusvr_svmreg_filename"]))
Base.Test.@test(!isfile(ENV["knetmlpreg_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
ENV["SAVETRAINEDMODELSTOFILE"] = "true"
include("run_bostonhousing.jl")

Base.Test.@test(isfile(ENV["linearreg_filename"]))
Base.Test.@test(isfile(ENV["randomforestreg_filename"]))
Base.Test.@test(isfile(ENV["epsilonsvr_svmreg_filename"]))
Base.Test.@test(isfile(ENV["nusvr_svmreg_filename"]))
Base.Test.@test(isfile(ENV["knetmlpreg_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
ENV["SAVETRAINEDMODELSTOFILE"] = "false"
include("run_bostonhousing.jl")
