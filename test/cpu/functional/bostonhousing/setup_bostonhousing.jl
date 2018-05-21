ENV["linearreg_filename"] = string(tempname(), "_linearreg.jld2")
ENV["randomforestreg_filename"] = string(tempname(), "_randomforestreg.jld2")
ENV["knetmlpreg_filename"] = string(tempname(), "_knetmlpreg.jld2")

Base.Test.@test( !isfile( ENV["linearreg_filename"] ) )
Base.Test.@test( !isfile( ENV["randomforestreg_filename"] ) )
Base.Test.@test( !isfile( ENV["knetmlpreg_filename"] ) )
#
Base.Test.@test( !PredictMD.something_exists_at_path( ENV["linearreg_filename"] ) )
Base.Test.@test( !PredictMD.something_exists_at_path( ENV["randomforestreg_filename"] ) )
Base.Test.@test( !PredictMD.something_exists_at_path( ENV["knetmlpreg_filename"] ) )

ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
ENV["SAVETRAINEDMODELSTOFILE"] = "true"
include("run_bostonhousing.jl")

Base.Test.@test( isfile( ENV["linearreg_filename"] ) )
Base.Test.@test( isfile( ENV["randomforestreg_filename"] ) )
Base.Test.@test( isfile( ENV["knetmlpreg_filename"] ) )
#
Base.Test.@test( PredictMD.something_exists_at_path( ENV["linearreg_filename"] ) )
Base.Test.@test( PredictMD.something_exists_at_path( ENV["randomforestreg_filename"] ) )
Base.Test.@test( PredictMD.something_exists_at_path( ENV["knetmlpreg_filename"] ) )

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
ENV["SAVETRAINEDMODELSTOFILE"] = "false"
include("run_bostonhousing.jl")

Base.Test.@test( isfile( ENV["linearreg_filename"] ) )
Base.Test.@test( isfile( ENV["randomforestreg_filename"] ) )
Base.Test.@test( isfile( ENV["knetmlpreg_filename"] ) )
#
Base.Test.@test( PredictMD.something_exists_at_path( ENV["linearreg_filename"] ) )
Base.Test.@test( PredictMD.something_exists_at_path( ENV["randomforestreg_filename"] ) )
Base.Test.@test( PredictMD.something_exists_at_path( ENV["knetmlpreg_filename"] ) )
