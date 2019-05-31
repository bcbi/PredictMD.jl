##### Beginning of file

import PredictMD
import Test

Test.@test( isa(Test.@inferred(PredictMD.version_codename()), String) )

Test.@test( length(Test.@inferred(PredictMD.version_codename())) > 0 )

Test.@test(
    Test.@inferred(PredictMD.version_codename()) ==
        Test.@inferred(PredictMD.version_codename(PredictMD))
    )

Test.@test(
    Test.@inferred(PredictMD.version_codename()) ==
        Test.@inferred(
            PredictMD.version_codename(first(methods(PredictMD.eval)))
            )
    )

Test.@test(
    Test.@inferred(PredictMD.version_codename()) ==
        Test.@inferred(PredictMD.version_codename(PredictMD.eval))
    )

Test.@test(
    Test.@inferred(PredictMD.version_codename()) ==
        Test.@inferred(
            PredictMD.version_codename(PredictMD.eval, (Any,),)
            )
    )

Test.@test(
    Test.@inferred(PredictMD.version_codename(TestModuleA)) ==
        "Code name for TestModuleA"
    )

Test.@test(
    Test.@inferred(PredictMD.version_codename(TestModuleB)) ==
        "TestModuleB code name"
    )

Test.@test_throws(
    ErrorException,
    PredictMD._TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file
