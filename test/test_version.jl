##### Beginning of file

import PredictMD
import Test

Test.@test( Base.VERSION >= VersionNumber("1.0") )

Test.@test( PredictMD.version() > VersionNumber(0) )

Test.@test(
    PredictMD.version() ==
        PredictMD.version(PredictMD)
    )

Test.@test(
    PredictMD.version() ==
        PredictMD.version(first(methods(PredictMD.eval)))
    )

Test.@test(
    PredictMD.version() ==
        PredictMD.version(PredictMD.eval)
    )

Test.@test(
    PredictMD.version() ==
        PredictMD.version(PredictMD.eval, (Any,))
    )

Test.@test( PredictMD.version(TestModuleA) == VersionNumber("1.2.3") )

Test.@test( PredictMD.version(TestModuleB) == VersionNumber("4.5.6") )

Test.@test_throws(
    ErrorException,
    PredictMD.TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file
