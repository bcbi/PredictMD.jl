ENV["logisticclassifier_filename"] = string(tempname(), "_logisticclassifier.jld2")
ENV["rfclassifier_filename"] = string(tempname(), "_rfclassifier.jld2")
ENV["csvc_svmclassifier_filename"] = string(tempname(), "_csvc_svmclassifier.jld2")
ENV["nusvc_svmclassifier_filename"] = string(tempname(), "_nusvc_svmclassifier.jld2")
ENV["knetmlp_filename"] = string(tempname(), "_knetmlpclassifier.jld2")

Base.Test.@test(!isfile(ENV["logisticclassifier_filename"]))
Base.Test.@test(!isfile(ENV["rfclassifier_filename"]))
Base.Test.@test(!isfile(ENV["csvc_svmclassifier_filename"]))
Base.Test.@test(!isfile(ENV["nusvc_svmclassifier_filename"]))
Base.Test.@test(!isfile(ENV["knetmlp_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
ENV["SAVETRAINEDMODELSTOFILE"] = "true"
include("run_breastcancerbiopsy.jl")

Base.Test.@test(isfile(ENV["logisticclassifier_filename"]))
Base.Test.@test(isfile(ENV["rfclassifier_filename"]))
Base.Test.@test(isfile(ENV["csvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["nusvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["knetmlp_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
ENV["SAVETRAINEDMODELSTOFILE"] = "false"
include("run_breastcancerbiopsy.jl")

Base.Test.@test(isfile(ENV["logisticclassifier_filename"]))
Base.Test.@test(isfile(ENV["rfclassifier_filename"]))
Base.Test.@test(isfile(ENV["csvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["nusvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["knetmlp_filename"]))
