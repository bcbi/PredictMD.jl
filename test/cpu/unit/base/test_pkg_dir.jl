##### Beginning of file

import Test
import PredictMD

a = PredictMD.package_directory()
Test.@test( isdir(a) )

b = PredictMD.package_directory(
    "assets",
    )
Test.@test( isdir(b) )
Test.@test( dirname(b) == a )

c = PredictMD.package_directory(
    "assets",
    "icd",
    )
Test.@test( isdir(c) )
Test.@test( dirname(c) == b )

d = PredictMD.package_directory(
    "assets",
    "icd",
    "icd9",
    )
Test.@test( isdir(d) )
Test.@test( dirname(d) == c )

e = PredictMD.package_directory(
    "assets",
    "icd",
    "icd9",
    "ccs"
    )
Test.@test( isdir(e) )
Test.@test( dirname(e) == d )

f = PredictMD.package_directory(
    "assets",
    "icd",
    "icd9",
    "ccs",
    "AppendixASingleDX.txt"
    )
Test.@test( dirname(f) == e )
Test.@test( isfile(f) )

##### End of file
