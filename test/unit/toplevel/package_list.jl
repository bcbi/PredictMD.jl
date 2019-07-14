import PredictMD
import Test

if PredictMD.is_travis_ci()
    Test.@testset "Testing print_list_of_package_imports()" begin
        PredictMD.print_list_of_package_imports()
    end
end
