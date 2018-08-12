##### Beginning of file

import Base.Test
import PredictMD

a = PredictMD.pkg_dir()
Base.Test.@test( isdir(a) )

b = PredictMD.pkg_dir(
    "assets",
    )
Base.Test.@test( isdir(b) )
Base.Test.@test( dirname(b) == a )

c = PredictMD.pkg_dir(
    "assets",
    "icd",
    )
Base.Test.@test( isdir(c) )
Base.Test.@test( dirname(c) == b )

d = PredictMD.pkg_dir(
    "assets",
    "icd",
    "icd9",
    )
Base.Test.@test( isdir(d) )
Base.Test.@test( dirname(d) == c )

e = PredictMD.pkg_dir(
    "assets",
    "icd",
    "icd9",
    "ccs"
    )
Base.Test.@test( isdir(e) )
Base.Test.@test( dirname(e) == d )

f = PredictMD.pkg_dir(
    "assets",
    "icd",
    "icd9",
    "ccs",
    "AppendixASingleDX.txt"
    )
Base.Test.@test( dirname(f) == e )
Base.Test.@test( isfile(f) )

##### End of file
