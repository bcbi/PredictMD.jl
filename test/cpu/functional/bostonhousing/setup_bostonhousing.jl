ENV["linearreg_filename"] = string(tempname(), "_linearreg.bson")
ENV["randomforestreg_filename"] = string(tempname(), "_randomforestreg.bson")
ENV["epsilonsvr_svmreg_filename"] = string(tempname(), "_epsilonsvr_svmreg.bson")
ENV["nusvr_svmreg_filename"] = string(tempname(), "_nusvr_svmreg.bson")
ENV["knetmlpreg_filename"] = string(tempname(), "_knetmlpreg.bson")

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
