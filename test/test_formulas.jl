using DataFrames

myformula1a = AluthgeSinhaBase.generate_formula_object(
    [:y],[:a,:b,:c],
    )
myformula1b = [DataFrames.@formula(y ~ 1 + a + b + c)]
@test(myformula1a[1].lhs == myformula1b[1].lhs)
@test(myformula1a[1].rhs == myformula1b[1].rhs)

myformula2a = AluthgeSinhaBase.generate_formula_object(
    :y,[:a, :b, :c],
    )
myformula2b = DataFrames.@formula(y ~ 1 + a + b + c)
@test(myformula2a.lhs == myformula2b.lhs)
@test(myformula2a.rhs == myformula2b.rhs)

myformula3a = AluthgeSinhaBase.generate_formula_object(
    [:y],[:a,:b,:c];
    intercept=false,
    )
myformula3b = [DataFrames.@formula(y ~ 0 + a + b + c)]
@test(myformula3a[1].lhs == myformula3b[1].lhs)
@test(myformula3a[1].rhs == myformula3b[1].rhs)

myformula4a = AluthgeSinhaBase.generate_formula_object(
    :y,[:a, :b, :c];
    intercept=false,
    )
myformula4b = DataFrames.@formula(y ~ 0 + a + b + c)
@test(myformula4a.lhs == myformula4b.lhs)
@test(myformula4a.rhs == myformula4b.rhs)

myformula5a = AluthgeSinhaBase.generate_formula_object(
    [:y, :z],[:a,:b,:c],
    )
myformula5b = [
    DataFrames.@formula(y ~ 1 + a + b + c),
    DataFrames.@formula(z ~ 1 + a + b + c),
    ]
@test(myformula5a[1].lhs == myformula5b[1].lhs)
@test(myformula5a[1].rhs == myformula5b[1].rhs)
@test(myformula5a[2].lhs == myformula5b[2].lhs)
@test(myformula5a[2].rhs == myformula5b[2].rhs)

myformula6a = AluthgeSinhaBase.generate_formula_object(
    [:y, :z],[:a,:b,:c];
    intercept=false,
    )
myformula6b = [
    DataFrames.@formula(y ~ 0 + a + b + c),
    DataFrames.@formula(z ~ 0 + a + b + c),
    ]
@test(myformula6a[1].lhs == myformula6b[1].lhs)
@test(myformula6a[1].rhs == myformula6b[1].rhs)
@test(myformula6a[2].lhs == myformula6b[2].lhs)
@test(myformula6a[2].rhs == myformula6b[2].rhs)
