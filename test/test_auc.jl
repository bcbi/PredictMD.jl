x1 = convert(Array, linspace(0,13,10_000))
y1 = x1.^3
@test(
    isapprox(
        AluthgeSinhaBase.areaundercurve(x1, y1),
        28561/4;
        )
    )

x2 = convert(Array, linspace(-20,20,10_000))
y2 = cos.(x2)
@test(
    isapprox(
        AluthgeSinhaBase.areaundercurve(x2, y2),
        2*sin(20);
        atol=0.00001
        )
    )
