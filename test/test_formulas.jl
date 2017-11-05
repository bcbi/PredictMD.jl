using StatsModels

myformula1a = AluthgeSinhaBase.generate_formula(
    [:y],[:a,:b,:c],
    )
myformula1b = StatsModels.@formula(y ~ 1 + a + b + c)
@test(myformula1a == myformula1b)

myformula2a = AluthgeSinhaBase.generate_formula(
    :y,[:a, :b, :c],
    )
myformula2b = StatsModels.@formula(y ~ 1 + a + b + c)
@test(myformula2a == myformula2b)

myformula3a = AluthgeSinhaBase.generate_formula(
    [:y],[:a,:b,:c];
    intercept=false,
    )
myformula3b = StatsModels.@formula(y ~ 0 + a + b + c)
@test(myformula3a == myformula3b)

myformula4a = AluthgeSinhaBase.generate_formula(
    :y,[:a, :b, :c];
    intercept=false,
    )
myformula4b = StatsModels.@formula(y ~ 0 + a + b + c)
@test(myformula4a == myformula4b)
