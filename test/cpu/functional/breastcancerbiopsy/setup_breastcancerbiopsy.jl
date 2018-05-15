ENV["logisticclassifier_filename"] = string(tempname(), "_logisticclassifier.bson")
ENV["probitclassifier_filename"] = string(tempname(), "_probitclassifier.bson")
ENV["rfclassifier_filename"] = string(tempname(), "_rfclassifier.bson")
ENV["csvc_svmclassifier_filename"] = string(tempname(), "_csvc_svmclassifier.bson")
ENV["nusvc_svmclassifier_filename"] = string(tempname(), "_nusvc_svmclassifier.bson")
ENV["knetmlp_filename"] = string(tempname(), "_knetmlpclassifier.bson")

Base.Test.@test(!isfile(ENV["logisticclassifier_filename"]))
Base.Test.@test(!isfile(ENV["probitclassifier_filename"]))
Base.Test.@test(!isfile(ENV["rfclassifier_filename"]))
Base.Test.@test(!isfile(ENV["csvc_svmclassifier_filename"]))
Base.Test.@test(!isfile(ENV["nusvc_svmclassifier_filename"]))
Base.Test.@test(!isfile(ENV["knetmlp_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
ENV["SAVETRAINEDMODELSTOFILE"] = "true"
include("run_breastcancerbiopsy.jl")

Base.Test.@test(isfile(ENV["logisticclassifier_filename"]))
Base.Test.@test(isfile(ENV["probitclassifier_filename"]))
Base.Test.@test(isfile(ENV["rfclassifier_filename"]))
Base.Test.@test(isfile(ENV["csvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["nusvc_svmclassifier_filename"]))
Base.Test.@test(isfile(ENV["knetmlp_filename"]))

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
ENV["SAVETRAINEDMODELSTOFILE"] = "false"
include("run_breastcancerbiopsy.jl")
