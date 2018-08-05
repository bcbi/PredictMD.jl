import PredictMD

a = PredictMD.predictmd_package_directory()
Base.Test.@test( isdir(a) )

b = PredictMD.predictmd_package_directory(
    "assets",
    )
Base.Test.@test( isdir(b) )
Base.Test.@test( dirname(b) == a )

c = PredictMD.predictmd_package_directory(
    "assets",
    "icd",
    )
Base.Test.@test( isdir(c) )
Base.Test.@test( dirname(c) == b )

d = PredictMD.predictmd_package_directory(
    "assets",
    "icd",
    "icd9",
    )
Base.Test.@test( isdir(d) )
Base.Test.@test( dirname(d) == c )

e = PredictMD.predictmd_package_directory(
    "assets",
    "icd",
    "icd9",
    "ccs"
    )
Base.Test.@test( isdir(e) )
Base.Test.@test( dirname(e) == d )

f = PredictMD.predictmd_package_directory(
    "assets",
    "icd",
    "icd9",
    "ccs",
    "AppendixASingleDX.txt"
    )
Base.Test.@test( dirname(f) == e )
Base.Test.@test( isfile(f) )
