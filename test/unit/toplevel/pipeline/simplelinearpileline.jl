import PredictMD
import Test

Test.@test Base.IteratorSize(PredictMD.SimplePipeline) == Base.HasLength()
Test.@test Base.IteratorEltype(PredictMD.SimplePipeline) == Base.HasEltype()
# Test.@test Base.IndexStyle(PredictMD.SimplePipeline) == Base.IndexCartesian()
# Test.@test Base.IndexStyle(PredictMD.SimplePipeline) == Base.IndexLinear()

a = PredictMD.SimplePipeline("name", PredictMD.AbstractFittable[])
Test.@test a isa PredictMD.SimplePipeline
Test.@test isempty(a)
Test.@test length(a) == 0
PredictMD.get_underlying(a)
PredictMD.get_history(a)
empty!(a)

b = Foo_Fittable() |> Bar_Fittable()
c = Foo_Fittable() |> Bar_Fittable() |> Baz_Fittable()
d = Foo_Fittable() |> Bar_Fittable() |> Baz_Fittable() |> Foo_Fittable() |> Bar_Fittable() |> Baz_Fittable()
e = PredictMD.SimplePipeline("name", PredictMD.AbstractFittable[Baz_Fittable()])

Test.@test b isa PredictMD.SimplePipeline
Test.@test c isa PredictMD.SimplePipeline
Test.@test d isa PredictMD.SimplePipeline
Test.@test e isa PredictMD.SimplePipeline

Test.@test !isempty(b)
Test.@test !isempty(c)
Test.@test !isempty(d)
Test.@test !isempty(e)

Test.@test length(b) == 2
Test.@test length(c) == 3
Test.@test length(d) == 6
Test.@test length(e) == 1

Test.@test b[1] == Foo_Fittable()
Test.@test b[2] == Bar_Fittable()

Test.@test c[1] == Foo_Fittable()
Test.@test c[2] == Bar_Fittable()
Test.@test c[3] == Baz_Fittable()
Test.@test c[1:3] == [Foo_Fittable(), Bar_Fittable(), Baz_Fittable()]
Test.@test view(c, 2:3)[1] == Bar_Fittable()
Test.@test view(c, 2:3)[2] == Baz_Fittable()

for x in c
    Test.@test x isa PredictMD.AbstractFittable
end

c[2] = Foo_Fittable()
Test.@test c[1] == Foo_Fittable()
Test.@test c[2] == Foo_Fittable()
Test.@test c[3] == Baz_Fittable()

Test.@test e[1] == Baz_Fittable()
for x in e
    Test.@test x == Baz_Fittable()
end
Test.@test isassigned(e, 1)

Test.@test isa(Foo_Fittable() |> Bar_Fittable(), SimplePipeline)
Test.@test isa(SimplePipeline("", [Foo_Fittable()]) |> Bar_Fittable(), SimplePipeline)
Test.@test isa(Foo_Fittable() |> SimplePipeline("", [Bar_Fittable()]), SimplePipeline)
Test.@test isa(SimplePipeline("", [Foo_Fittable()]) |> SimplePipeline("", [Bar_Fittable()]), SimplePipeline)
