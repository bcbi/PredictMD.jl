using DataFrames

myformulas1a = AluthgeSinhaBase.generate_formula_object(
    [:y],[:a,:b,:c],
    )
myformulas1b = [DataFrames.@formula(y ~ 1 + a + b + c)]
@test(myformulas1a[1].lhs == myformulas1b[1].lhs)
@test(myformulas1a[1].rhs == myformulas1b[1].rhs)

myformula2a = AluthgeSinhaBase.generate_formula_object(
    :y,[:a, :b, :c],
    )
myformula2b = DataFrames.@formula(y ~ 1 + a + b + c)
@test(myformula2a.lhs == myformula2b.lhs)
@test(myformula2a.rhs == myformula2b.rhs)

myformulas3a = AluthgeSinhaBase.generate_formula_object(
    [:y],[:a,:b,:c];
    intercept=false,
    )
myformulas3b = [DataFrames.@formula(y ~ 0 + a + b + c)]
@test(myformulas3a[1].lhs == myformulas3b[1].lhs)
@test(myformulas3a[1].rhs == myformulas3b[1].rhs)

myformula4a = AluthgeSinhaBase.generate_formula_object(
    :y,[:a, :b, :c];
    intercept=false,
    )
myformula4b = DataFrames.@formula(y ~ 0 + a + b + c)
@test(myformula4a.lhs == myformula4b.lhs)
@test(myformula4a.rhs == myformula4b.rhs)

myformulas5a = AluthgeSinhaBase.generate_formula_object(
    [:y, :z],[:a,:b,:c],
    )
myformulas5b = [
    DataFrames.@formula(y ~ 1 + a + b + c),
    DataFrames.@formula(z ~ 1 + a + b + c),
    ]
@test(myformulas5a[1].lhs == myformulas5b[1].lhs)
@test(myformulas5a[1].rhs == myformulas5b[1].rhs)
@test(myformulas5a[2].lhs == myformulas5b[2].lhs)
@test(myformulas5a[2].rhs == myformulas5b[2].rhs)

myformulas6a = AluthgeSinhaBase.generate_formula_object(
    [:y, :z],[:a,:b,:c];
    intercept=false,
    )
myformulas6b = [
    DataFrames.@formula(y ~ 0 + a + b + c),
    DataFrames.@formula(z ~ 0 + a + b + c),
    ]
@test(myformulas6a[1].lhs == myformulas6b[1].lhs)
@test(myformulas6a[1].rhs == myformulas6b[1].rhs)
@test(myformulas6a[2].lhs == myformulas6b[2].lhs)
@test(myformulas6a[2].rhs == myformulas6b[2].rhs)
