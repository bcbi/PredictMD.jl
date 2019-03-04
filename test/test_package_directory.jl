##### Beginning of file

import PredictMD
import Test

Test.@test( isdir(PredictMD.package_directory()) )

Test.@test( isdir(PredictMD.package_directory("ci")) )

Test.@test( isdir(PredictMD.package_directory("ci", "travis")) )

Test.@test( isdir(PredictMD.package_directory(TestModuleA)) )

Test.@test( isdir(PredictMD.package_directory(TestModuleB)) )

Test.@test( isdir( PredictMD.package_directory(
            TestModuleB, "directory2",
            ) ) )

Test.@test( isdir( PredictMD.package_directory(
            TestModuleB, "directory2", "directory3",
            ) ) )

Test.@test_throws(
    ErrorException,
    PredictMD.package_directory(TestModuleC),
    )

##### End of file
