import PredictMD
import Test

Test.@test( isdir(PredictMD.package_directory()) )

Test.@test( isdir(PredictMD.package_directory("ci")) )

Test.@test( isdir(PredictMD.package_directory("ci", "travis")) )

Test.@test( isdir(PredictMD.package_directory(PredictMDTestModuleA)) )

Test.@test( isdir(PredictMD.package_directory(PredictMDTestModuleB)) )

Test.@test( isdir( PredictMD.package_directory(
            PredictMDTestModuleB, "directory2",
            ) ) )

Test.@test( isdir( PredictMD.package_directory(
            PredictMDTestModuleB, "directory2", "directory3",
            ) ) )

Test.@test_throws(
    ErrorException,
    PredictMD.package_directory(PredictMDTestModuleC),
    )

