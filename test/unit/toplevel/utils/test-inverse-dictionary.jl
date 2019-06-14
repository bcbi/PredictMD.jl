##### Beginning of file

import Test
import PredictMD

dict_1 = Dict()
Test.@test( PredictMD.is_one_to_one(dict_1) )
dict_1_inverted = PredictMD.inverse(dict_1)

dict_2 = Dict()
dict_2["hello"] = :hola
dict_2["goodbye"] = :adios
Test.@test( PredictMD.is_one_to_one(dict_2) )
dict_2_inverted = PredictMD.inverse(dict_2)
Test.@test( dict_2_inverted[:hola] == "hello" )
Test.@test( dict_2_inverted[:adios] ==  "goodbye")


dict_3 = Dict()
dict_3[1] = "odd"
dict_3[2] = "even"
dict_3[3] = "odd"
Test.@test( !PredictMD.is_one_to_one(dict_3) )
Test.@test_throws(ErrorException, PredictMD.inverse(dict_3))

##### End of file
