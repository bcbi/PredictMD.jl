x1 = convert(Array, linspace(0,13,10_000))
y1 = x1.^3
@test(
    isapprox(
        AluthgeSinhaBase.areaundercurveinterpolated(x1, y1),
        28561/4
        )
    )

x2 = convert(Array, linspace(-20,20,10_000))
y2 = cos.(x2)
@test(
    isapprox(
        AluthgeSinhaBase.areaundercurveinterpolated(x2, y2),
        2*sin(20),
        atol=0.00001,
        )
    )

x3 = convert(Array, linspace(1e-10,1,10_000))
y3 = x3.*sin.(1./x3)
@test(
    isapprox(
        AluthgeSinhaBase.areaundercurveinterpolated(x3, y3),
        0.37853,
        atol=0.00001,
        )
    )

##############################################################################

x0 = [4, 6, 8]
y0 = [1, 2, 3]

@test( AluthgeSinhaBase.trapz(x0, y0) == 8 )


x1 = convert(Array, linspace(0,13,10_000))
y1 = x1.^3
@test(
    isapprox(
        AluthgeSinhaBase.trapz(x1, y1),
        28561/4,
        )
    )

x2 = convert(Array, linspace(-20,20,10_000))
y2 = cos.(x2)
@test(
    isapprox(
        AluthgeSinhaBase.trapz(x2, y2),
        2*sin(20),
        atol=0.00001,
        )
    )

x3 = convert(Array, linspace(1e-10,1,10_000))
y3 = x3.*sin.(1./x3)
@test(
    isapprox(
        AluthgeSinhaBase.trapz(x3, y3),
        0.37853,
        atol=0.00001,
        )
    )
