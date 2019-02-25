##### Beginning of file

import PredictMD
import Test

Test.@test(typeof(PredictMD._registry_url_list()) <: Vector{String})
Test.@test(length(PredictMD._registry_url_list()) > 0)

##### End of file
