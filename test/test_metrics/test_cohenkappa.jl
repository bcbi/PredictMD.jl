table1 = [20 5; 10 15]
Base.Test.@test( isapprox(asb.cohenkappa(table1), 0.4; atol = 0.00000000001))

table2 = [45 15; 25 15]
Base.Test.@test( isapprox(asb.cohenkappa(table2), 0.1304; atol = 0.0001))

table3 = [25 35; 5 35]
Base.Test.@test( isapprox(asb.cohenkappa(table3), 0.2593; atol = 0.0001))

table4 = [9 3 1; 4 8 2 ; 2 1 6]
Base.Test.@test( isapprox(asb.cohenkappa(table4), 0.45; atol = 0.001))
