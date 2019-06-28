import PredictMD
import Test

if PredictMD.is_travis_ci_on_linux()
    Test.@test( PredictMD.is_filesystem_root("/") )
    Test.@test_throws(ErrorException, PredictMD.find_package_directory("/"))
end
