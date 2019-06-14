##### Beginning of file

import Test
import PredictMD

table1 = [20 5; 10 15]
Test.@test(
    isapprox(PredictMD.cohen_kappa(table1), 0.4; atol = 0.00000000001)
    )

table2 = [45 15; 25 15]
Test.@test(
    isapprox(PredictMD.cohen_kappa(table2), 0.1304; atol = 0.0001)
    )

table3 = [25 35; 5 35]
Test.@test(
    isapprox(PredictMD.cohen_kappa(table3), 0.2593; atol = 0.0001)
    )

table4 = [9 3 1; 4 8 2 ; 2 1 6]
Test.@test(
    isapprox(PredictMD.cohen_kappa(table4), 0.45; atol = 0.001)
    )

##### End of file
