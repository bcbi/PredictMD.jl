import PredictMD
import Test

Test.@test Base.IteratorEltype(PredictMD.SimplePipeline{String, Vector}) == Base.HasEltype()
Test.@test Base.IteratorSize(PredictMD.SimplePipeline{String, Vector}) == Base.HasShape{1}()
Test.@test Base.IndexStyle(PredictMD.SimplePipeline{String, Vector}) == Base.IndexLinear()

a = PredictMD.SimplePipeline("name", PredictMD.AbstractFittable[])
Test.@test PredictMD.ispipeline(a)
Test.@test PredictMD.isflat(a)
Test.@test a isa PredictMD.SimplePipeline
Test.@test isempty(a)
Test.@test length(a) == 0
Test.@test ndims(a) == 1
Test.@test length(size(a)) == 1
Test.@test size(a) == (0,)
Test.@test size(a)[1] == 0
PredictMD.get_underlying(a)
PredictMD.get_history(a)
empty!(a)

Test.@test !PredictMD.ispipeline(Foo_Fittable(0))

b = Foo_Fittable(11) |> Bar_Fittable(22)
c = Foo_Fittable(11) |> Bar_Fittable(22) |> Baz_Fittable(30)
d = Foo_Fittable(11) |> Bar_Fittable(22) |> Baz_Fittable(30) |> Foo_Fittable(40) |> Bar_Fittable(50) |> Baz_Fittable(60)
e = PredictMD.SimplePipeline("name", PredictMD.AbstractFittable[Baz_Fittable(11)])

Test.@test PredictMD.ispipeline(b)
Test.@test PredictMD.ispipeline(c)
Test.@test PredictMD.ispipeline(d)
Test.@test PredictMD.ispipeline(e)

Test.@test PredictMD.isflat(b)
Test.@test PredictMD.isflat(c)
Test.@test PredictMD.isflat(d)
Test.@test PredictMD.isflat(e)

Test.@test b isa PredictMD.SimplePipeline
Test.@test c isa PredictMD.SimplePipeline
Test.@test d isa PredictMD.SimplePipeline
Test.@test e isa PredictMD.SimplePipeline

Test.@test !isempty(b)
Test.@test !isempty(c)
Test.@test !isempty(d)
Test.@test !isempty(e)

Test.@test length(b) == 2
Test.@test ndims(b) == 1
Test.@test length(size(b)) == 1
Test.@test size(b) == (2,)
Test.@test size(b)[1] == 2

Test.@test length(c) == 3
Test.@test ndims(c) == 1
Test.@test length(size(c)) == 1
Test.@test size(c) == (3,)
Test.@test size(c)[1] == 3

Test.@test length(d) == 6
Test.@test ndims(d) == 1
Test.@test length(size(d)) == 1
Test.@test size(d) == (6,)
Test.@test size(d)[1] == 6

Test.@test length(e) == 1
Test.@test ndims(e) == 1
Test.@test length(size(e)) == 1
Test.@test size(e) == (1,)
Test.@test size(e)[1] == 1

Test.@test b[1] == Foo_Fittable(11)
Test.@test b[2] == Bar_Fittable(22)

Test.@test c[1] == Foo_Fittable(11)
Test.@test c[2] == Bar_Fittable(22)
Test.@test c[3] == Baz_Fittable(30)
Test.@test c[1:3] == [Foo_Fittable(11), Bar_Fittable(22), Baz_Fittable(30)]
Test.@test view(c, 2:3)[1] == Bar_Fittable(22)
Test.@test view(c, 2:3)[2] == Baz_Fittable(30)

for x in c
    Test.@test x isa PredictMD.AbstractFittable
end

c[2] = Foo_Fittable(22)
Test.@test c[1] == Foo_Fittable(11)
Test.@test c[2] == Foo_Fittable(22)
Test.@test c[3] == Baz_Fittable(30)

Test.@test e[1] == Baz_Fittable(11)
for x in e
    Test.@test x == Baz_Fittable(11)
end
Test.@test isassigned(e, 1)

Test.@test isa(Foo_Fittable(11) |> Bar_Fittable(22), PredictMD.SimplePipeline)
Test.@test isa(PredictMD.SimplePipeline("", [Foo_Fittable(11)]) |> Bar_Fittable(22), PredictMD.SimplePipeline)
Test.@test isa(Foo_Fittable(11) |> PredictMD.SimplePipeline("", [Bar_Fittable(22)]), PredictMD.SimplePipeline)
Test.@test isa(PredictMD.SimplePipeline("", [Foo_Fittable(11)]) |> PredictMD.SimplePipeline("", [Bar_Fittable(22)]), PredictMD.SimplePipeline)

f = Foo_Fittable(1) |> Foo_Fittable(2) |> Foo_Fittable(3) |> Foo_Fittable(4) |> Foo_Fittable(5) |> Foo_Fittable(6) |> Foo_Fittable(7)
Test.@test PredictMD.ispipeline(f)
Test.@test PredictMD.isflat(f)
for x in f
    Test.@test x isa Foo_Fittable
end
for i = 1:length(f)
    Test.@test f[i] isa Foo_Fittable
    Test.@test f[i] == Foo_Fittable(i)
    Test.@test f[i].x == i
end
for i = 1:size(f,1)
    Test.@test f[i] isa Foo_Fittable
    Test.@test f[i] == Foo_Fittable(i)
    Test.@test f[i].x == i
end
for i = 1:size(f)[1]
    Test.@test f[i] isa Foo_Fittable
    Test.@test f[i] == Foo_Fittable(i)
    Test.@test f[i].x == i
end
Test.@test ndims(f) == 1
Test.@test length(f) == 7
Test.@test size(f) == (7,)
Test.@test size(f)[1] == 7
Test.@test length(size(f)) == 1

g = Foo_Fittable(1) |> Bar_Fittable(2) |> Baz_Fittable(3) |> Foo_Fittable(4) |> Bar_Fittable(5) |> Baz_Fittable(6) |> Foo_Fittable(7)
Test.@test PredictMD.ispipeline(g)
Test.@test PredictMD.isflat(g)
for x in g
    Test.@test x isa PredictMD.AbstractFittable
end
for i = 1:length(g)
    Test.@test g[i] isa PredictMD.AbstractFittable
    Test.@test g[i].x == i
end
for i = 1:size(g,1)
    Test.@test g[i] isa PredictMD.AbstractFittable
    Test.@test g[i].x == i
end
for i = 1:size(g)[1]
    Test.@test g[i] isa PredictMD.AbstractFittable
    Test.@test g[i].x == i
end
Test.@test ndims(g) == 1
Test.@test length(g) == 7
Test.@test size(g) ==(7,)
Test.@test size(g)[1] == 7
Test.@test length(size(g)) == 1

h = Foo_Fittable(11) |> Bar_Fittable(22)
i = PredictMD.SimplePipeline([Foo_Fittable(11)]) |> Bar_Fittable(22)
j = Foo_Fittable(11) |> PredictMD.SimplePipeline([Bar_Fittable(22)])
k = PredictMD.SimplePipeline([Foo_Fittable(11)]) |> PredictMD.SimplePipeline([Bar_Fittable(22)])

Test.@test PredictMD.ispipeline(h)
Test.@test PredictMD.ispipeline(i)
Test.@test PredictMD.ispipeline(j)
Test.@test PredictMD.ispipeline(k)

Test.@test PredictMD.isflat(h)
Test.@test PredictMD.isflat(i)
Test.@test PredictMD.isflat(j)
Test.@test PredictMD.isflat(k)

Test.@test h[1] == Foo_Fittable(11)
Test.@test i[1] == Foo_Fittable(11)
Test.@test j[1] == Foo_Fittable(11)
Test.@test k[1] == Foo_Fittable(11)

Test.@test h[2] == Bar_Fittable(22)
Test.@test i[2] == Bar_Fittable(22)
Test.@test j[2] == Bar_Fittable(22)
Test.@test k[2] == Bar_Fittable(22)

Test.@test h[1].x == 11
Test.@test i[1].x == 11
Test.@test j[1].x == 11
Test.@test k[1].x == 11

Test.@test h[2].x == 22
Test.@test i[2].x == 22
Test.@test j[2].x == 22
Test.@test k[2].x == 22

aa = PredictMD.SimplePipeline([Foo_Fittable(10), Foo_Fittable(20), Foo_Fittable(30)]; name = "aa")
bb = PredictMD.SimplePipeline([Foo_Fittable(40), Foo_Fittable(50), Foo_Fittable(60)]; name = "bb")
cc = PredictMD.SimplePipeline([Foo_Fittable(70), Foo_Fittable(80), Foo_Fittable(90)]; name = "cc")

Test.@test PredictMD.ispipeline(aa)
Test.@test PredictMD.ispipeline(bb)
Test.@test PredictMD.ispipeline(cc)

Test.@test PredictMD.isflat(aa)
Test.@test PredictMD.isflat(bb)
Test.@test PredictMD.isflat(cc)

dd = PredictMD.SimplePipeline([Foo_Fittable(100), Foo_Fittable(110), Foo_Fittable(120)]; name = "dd")
ee = PredictMD.SimplePipeline([Foo_Fittable(130), Foo_Fittable(140), Foo_Fittable(150)]; name = "ee")

Test.@test PredictMD.ispipeline(dd)
Test.@test PredictMD.ispipeline(ee)

Test.@test PredictMD.isflat(dd)
Test.@test PredictMD.isflat(ee)

ff = PredictMD.SimplePipeline([Foo_Fittable(160), Foo_Fittable(170), Foo_Fittable(180)]; name = "ff")
gg = PredictMD.SimplePipeline([Foo_Fittable(190), Foo_Fittable(200), Foo_Fittable(210)]; name = "gg")

Test.@test PredictMD.ispipeline(ff)
Test.@test PredictMD.ispipeline(gg)

Test.@test PredictMD.isflat(ff)
Test.@test PredictMD.isflat(gg)

hh = PredictMD.SimplePipeline([aa, bb, cc])
ii = PredictMD.SimplePipeline([dd, ee])
jj = PredictMD.SimplePipeline([ff, gg])

Test.@test PredictMD.ispipeline(hh)
Test.@test PredictMD.ispipeline(ii)
Test.@test PredictMD.ispipeline(jj)


Test.@test !PredictMD.isflat(hh)
Test.@test !PredictMD.isflat(ii)
Test.@test !PredictMD.isflat(jj)

kk = PredictMD.SimplePipeline([hh])
ll = PredictMD.SimplePipeline([ii, jj]) |> Foo_Fittable(220)

Test.@test PredictMD.ispipeline(kk)
Test.@test PredictMD.ispipeline(ll)
Test.@test !PredictMD.ispipeline(Foo_Fittable(220))

Test.@test !PredictMD.isflat(kk)
Test.@test !PredictMD.isflat(ll)

mm = PredictMD.SimplePipeline([kk, ll])
Test.@test PredictMD.ispipeline(mm)
Test.@test !PredictMD.isflat(mm)

mm_flattened = PredictMD.flatten(mm)
Test.@test PredictMD.ispipeline(mm_flattened)
Test.@test PredictMD.isflat(mm_flattened)
Test.@test mm_flattened isa PredictMD.SimplePipeline
for x in mm_flattened
    Test.@test x isa Foo_Fittable
end
for i = 1:length(mm_flattened)
    Test.@test mm_flattened[i] isa Foo_Fittable
    Test.@test mm_flattened[i] == Foo_Fittable(i*10)
    Test.@test mm_flattened[i].x == i*10
end
for i = 1:size(mm_flattened,1)
    Test.@test mm_flattened[i] isa Foo_Fittable
    Test.@test mm_flattened[i] == Foo_Fittable(i*10)
    Test.@test mm_flattened[i].x == i*10
end
for i = 1:size(mm_flattened)[1]
    Test.@test mm_flattened[i] isa Foo_Fittable
    Test.@test mm_flattened[i] == Foo_Fittable(i*10)
    Test.@test mm_flattened[i].x == i*10
end
Test.@test length(mm_flattened) == 22
Test.@test ndims(mm_flattened) == 1
Test.@test length(size(mm_flattened)) == 1
Test.@test size(mm_flattened) == (22,)
Test.@test size(mm_flattened)[1] == 22
Test.@test mm_flattened[1] == Foo_Fittable(10)
Test.@test mm_flattened[2] == Foo_Fittable(20)
Test.@test mm_flattened[3] == Foo_Fittable(30)
Test.@test mm_flattened[4] == Foo_Fittable(40)
Test.@test mm_flattened[5] == Foo_Fittable(50)
Test.@test mm_flattened[6] == Foo_Fittable(60)
Test.@test mm_flattened[7] == Foo_Fittable(70)
Test.@test mm_flattened[8] == Foo_Fittable(80)
Test.@test mm_flattened[9] == Foo_Fittable(90)
Test.@test mm_flattened[10] == Foo_Fittable(100)
Test.@test mm_flattened[11] == Foo_Fittable(110)
Test.@test mm_flattened[12] == Foo_Fittable(120)
Test.@test mm_flattened[13] == Foo_Fittable(130)
Test.@test mm_flattened[14] == Foo_Fittable(140)
Test.@test mm_flattened[15] == Foo_Fittable(150)
Test.@test mm_flattened[16] == Foo_Fittable(160)
Test.@test mm_flattened[17] == Foo_Fittable(170)
Test.@test mm_flattened[18] == Foo_Fittable(180)
Test.@test mm_flattened[19] == Foo_Fittable(190)
Test.@test mm_flattened[20] == Foo_Fittable(200)
Test.@test mm_flattened[21] == Foo_Fittable(210)
Test.@test mm_flattened[22] == Foo_Fittable(220)

mm_flat_on_creation_in_one_step_from_some_primitives = aa |> bb |> cc |> dd |> ee |> ff |> gg |> Foo_Fittable(220)

Test.@test PredictMD.ispipeline(mm_flat_on_creation_in_one_step_from_some_primitives)
Test.@test PredictMD.isflat(mm_flat_on_creation_in_one_step_from_some_primitives)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives isa PredictMD.SimplePipeline
for x in mm_flat_on_creation_in_one_step_from_some_primitives
    Test.@test x isa Foo_Fittable
end
for i = 1:length(mm_flat_on_creation_in_one_step_from_some_primitives)
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_one_step_from_some_primitives,1)
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_one_step_from_some_primitives)[1]
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[i].x == i*10
end
Test.@test length(mm_flat_on_creation_in_one_step_from_some_primitives) == 22
Test.@test ndims(mm_flat_on_creation_in_one_step_from_some_primitives) == 1
Test.@test length(size(mm_flat_on_creation_in_one_step_from_some_primitives)) == 1
Test.@test size(mm_flat_on_creation_in_one_step_from_some_primitives) == (22,)
Test.@test size(mm_flat_on_creation_in_one_step_from_some_primitives)[1] == 22
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[1] == Foo_Fittable(10)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[2] == Foo_Fittable(20)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[3] == Foo_Fittable(30)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[4] == Foo_Fittable(40)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[5] == Foo_Fittable(50)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[6] == Foo_Fittable(60)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[7] == Foo_Fittable(70)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[8] == Foo_Fittable(80)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[9] == Foo_Fittable(90)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[10] == Foo_Fittable(100)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[11] == Foo_Fittable(110)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[12] == Foo_Fittable(120)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[13] == Foo_Fittable(130)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[14] == Foo_Fittable(140)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[15] == Foo_Fittable(150)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[16] == Foo_Fittable(160)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[17] == Foo_Fittable(170)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[18] == Foo_Fittable(180)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[19] == Foo_Fittable(190)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[20] == Foo_Fittable(200)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[21] == Foo_Fittable(210)
Test.@test mm_flat_on_creation_in_one_step_from_some_primitives[22] == Foo_Fittable(220)

mm_flat_on_creation_in_one_step_from_all_primitives = Foo_Fittable(10) |> Foo_Fittable(20) |> Foo_Fittable(30) |> Foo_Fittable(40) |> Foo_Fittable(50) |> Foo_Fittable(60) |> Foo_Fittable(70) |> Foo_Fittable(80) |> Foo_Fittable(90) |> Foo_Fittable(100) |> Foo_Fittable(110) |> Foo_Fittable(120) |> Foo_Fittable(130) |> Foo_Fittable(140) |> Foo_Fittable(150) |> Foo_Fittable(160) |> Foo_Fittable(170) |> Foo_Fittable(180) |> Foo_Fittable(190) |> Foo_Fittable(200) |> Foo_Fittable(210) |> Foo_Fittable(220)

Test.@test PredictMD.ispipeline(mm_flat_on_creation_in_one_step_from_all_primitives)
Test.@test PredictMD.isflat(mm_flat_on_creation_in_one_step_from_all_primitives)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives isa PredictMD.SimplePipeline
for x in mm_flat_on_creation_in_one_step_from_all_primitives
    Test.@test x isa Foo_Fittable
end
for i = 1:length(mm_flat_on_creation_in_one_step_from_all_primitives)
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_one_step_from_all_primitives,1)
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_one_step_from_all_primitives)[1]
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[i].x == i*10
end
Test.@test length(mm_flat_on_creation_in_one_step_from_all_primitives) == 22
Test.@test ndims(mm_flat_on_creation_in_one_step_from_all_primitives) == 1
Test.@test length(size(mm_flat_on_creation_in_one_step_from_all_primitives)) == 1
Test.@test size(mm_flat_on_creation_in_one_step_from_all_primitives) == (22,)
Test.@test size(mm_flat_on_creation_in_one_step_from_all_primitives)[1] == 22
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[1] == Foo_Fittable(10)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[2] == Foo_Fittable(20)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[3] == Foo_Fittable(30)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[4] == Foo_Fittable(40)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[5] == Foo_Fittable(50)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[6] == Foo_Fittable(60)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[7] == Foo_Fittable(70)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[8] == Foo_Fittable(80)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[9] == Foo_Fittable(90)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[10] == Foo_Fittable(100)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[11] == Foo_Fittable(110)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[12] == Foo_Fittable(120)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[13] == Foo_Fittable(130)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[14] == Foo_Fittable(140)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[15] == Foo_Fittable(150)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[16] == Foo_Fittable(160)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[17] == Foo_Fittable(170)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[18] == Foo_Fittable(180)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[19] == Foo_Fittable(190)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[20] == Foo_Fittable(200)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[21] == Foo_Fittable(210)
Test.@test mm_flat_on_creation_in_one_step_from_all_primitives[22] == Foo_Fittable(220)

hh_flat = aa |> bb |> cc
ii_flat = dd |> ee
jj_flat = ff |> gg

kk_flat = hh_flat
ll_flat = ii_flat |> jj_flat |> Foo_Fittable(220)

mm_flat_on_creation_in_multiple_steps_from_some_primitives = kk_flat |> ll_flat

Test.@test !PredictMD.ispipeline(Foo_Fittable(220))

Test.@test PredictMD.ispipeline(aa)
Test.@test PredictMD.ispipeline(bb)
Test.@test PredictMD.ispipeline(cc)
Test.@test PredictMD.ispipeline(dd)
Test.@test PredictMD.ispipeline(ee)
Test.@test PredictMD.ispipeline(ff)
Test.@test PredictMD.ispipeline(gg)
Test.@test PredictMD.ispipeline(hh_flat)
Test.@test PredictMD.ispipeline(ii_flat)
Test.@test PredictMD.ispipeline(jj_flat)
Test.@test PredictMD.ispipeline(kk_flat)
Test.@test PredictMD.ispipeline(ll_flat)
Test.@test PredictMD.ispipeline(mm_flat_on_creation_in_multiple_steps_from_some_primitives)

Test.@test PredictMD.isflat(aa)
Test.@test PredictMD.isflat(bb)
Test.@test PredictMD.isflat(cc)
Test.@test PredictMD.isflat(dd)
Test.@test PredictMD.isflat(ee)
Test.@test PredictMD.isflat(ff)
Test.@test PredictMD.isflat(gg)
Test.@test PredictMD.isflat(hh_flat)
Test.@test PredictMD.isflat(ii_flat)
Test.@test PredictMD.isflat(jj_flat)
Test.@test PredictMD.isflat(kk_flat)
Test.@test PredictMD.isflat(ll_flat)
Test.@test PredictMD.isflat(mm_flat_on_creation_in_multiple_steps_from_some_primitives)

Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives isa PredictMD.SimplePipeline
for x in mm_flat_on_creation_in_multiple_steps_from_some_primitives
    Test.@test x isa Foo_Fittable
end
for i = 1:length(mm_flat_on_creation_in_multiple_steps_from_some_primitives)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_multiple_steps_from_some_primitives,1)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_multiple_steps_from_some_primitives)[1]
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[i].x == i*10
end
Test.@test length(mm_flat_on_creation_in_multiple_steps_from_some_primitives) == 22
Test.@test ndims(mm_flat_on_creation_in_multiple_steps_from_some_primitives) == 1
Test.@test length(size(mm_flat_on_creation_in_multiple_steps_from_some_primitives)) == 1
Test.@test size(mm_flat_on_creation_in_multiple_steps_from_some_primitives) == (22,)
Test.@test size(mm_flat_on_creation_in_multiple_steps_from_some_primitives)[1] == 22
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[1] == Foo_Fittable(10)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[2] == Foo_Fittable(20)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[3] == Foo_Fittable(30)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[4] == Foo_Fittable(40)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[5] == Foo_Fittable(50)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[6] == Foo_Fittable(60)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[7] == Foo_Fittable(70)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[8] == Foo_Fittable(80)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[9] == Foo_Fittable(90)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[10] == Foo_Fittable(100)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[11] == Foo_Fittable(110)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[12] == Foo_Fittable(120)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[13] == Foo_Fittable(130)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[14] == Foo_Fittable(140)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[15] == Foo_Fittable(150)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[16] == Foo_Fittable(160)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[17] == Foo_Fittable(170)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[18] == Foo_Fittable(180)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[19] == Foo_Fittable(190)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[20] == Foo_Fittable(200)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[21] == Foo_Fittable(210)
Test.@test mm_flat_on_creation_in_multiple_steps_from_some_primitives[22] == Foo_Fittable(220)

aa_frombasepipe = Foo_Fittable(10) |> Foo_Fittable(20) |> Foo_Fittable(30)
bb_frombasepipe = Foo_Fittable(40) |> Foo_Fittable(50) |> Foo_Fittable(60)
cc_frombasepipe = Foo_Fittable(70) |> Foo_Fittable(80) |> Foo_Fittable(90)
dd_frombasepipe = Foo_Fittable(100) |> Foo_Fittable(110) |> Foo_Fittable(120)
ee_frombasepipe = Foo_Fittable(130) |> Foo_Fittable(140) |> Foo_Fittable(150)
ff_frombasepipe = Foo_Fittable(160) |> Foo_Fittable(170) |> Foo_Fittable(180)
gg_frombasepipe = Foo_Fittable(190) |> Foo_Fittable(200) |> Foo_Fittable(210)

hh_flat = aa_frombasepipe |> bb_frombasepipe |> cc_frombasepipe
ii_flat = dd_frombasepipe |> ee_frombasepipe
jj_flat = ff_frombasepipe |> gg_frombasepipe

kk_flat = hh_flat
ll_flat = ii_flat |> jj_flat |> Foo_Fittable(220)

mm_flat_on_creation_in_multiple_steps_from_all_primitives = kk_flat |> ll_flat

Test.@test !PredictMD.ispipeline(Foo_Fittable(220))

Test.@test PredictMD.ispipeline(aa_frombasepipe)
Test.@test PredictMD.ispipeline(bb_frombasepipe)
Test.@test PredictMD.ispipeline(cc_frombasepipe)
Test.@test PredictMD.ispipeline(dd_frombasepipe)
Test.@test PredictMD.ispipeline(ee_frombasepipe)
Test.@test PredictMD.ispipeline(ff_frombasepipe)
Test.@test PredictMD.ispipeline(gg_frombasepipe)
Test.@test PredictMD.ispipeline(hh_flat)
Test.@test PredictMD.ispipeline(ii_flat)
Test.@test PredictMD.ispipeline(jj_flat)
Test.@test PredictMD.ispipeline(kk_flat)
Test.@test PredictMD.ispipeline(ll_flat)
Test.@test PredictMD.ispipeline(mm_flat_on_creation_in_multiple_steps_from_all_primitives)

Test.@test PredictMD.isflat(aa_frombasepipe)
Test.@test PredictMD.isflat(bb_frombasepipe)
Test.@test PredictMD.isflat(cc_frombasepipe)
Test.@test PredictMD.isflat(dd_frombasepipe)
Test.@test PredictMD.isflat(ee_frombasepipe)
Test.@test PredictMD.isflat(ff_frombasepipe)
Test.@test PredictMD.isflat(gg_frombasepipe)
Test.@test PredictMD.isflat(hh_flat)
Test.@test PredictMD.isflat(ii_flat)
Test.@test PredictMD.isflat(jj_flat)
Test.@test PredictMD.isflat(kk_flat)
Test.@test PredictMD.isflat(ll_flat)
Test.@test PredictMD.isflat(mm_flat_on_creation_in_multiple_steps_from_all_primitives)

Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives isa PredictMD.SimplePipeline
for x in mm_flat_on_creation_in_multiple_steps_from_all_primitives
    Test.@test x isa Foo_Fittable
end
for i = 1:length(mm_flat_on_creation_in_multiple_steps_from_all_primitives)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_multiple_steps_from_all_primitives,1)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i].x == i*10
end
for i = 1:size(mm_flat_on_creation_in_multiple_steps_from_all_primitives)[1]
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] isa Foo_Fittable
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i] == Foo_Fittable(i*10)
    Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[i].x == i*10
end
Test.@test length(mm_flat_on_creation_in_multiple_steps_from_all_primitives) == 22
Test.@test ndims(mm_flat_on_creation_in_multiple_steps_from_all_primitives) == 1
Test.@test length(size(mm_flat_on_creation_in_multiple_steps_from_all_primitives)) == 1
Test.@test size(mm_flat_on_creation_in_multiple_steps_from_all_primitives) == (22,)
Test.@test size(mm_flat_on_creation_in_multiple_steps_from_all_primitives)[1] == 22
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[1] == Foo_Fittable(10)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[2] == Foo_Fittable(20)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[3] == Foo_Fittable(30)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[4] == Foo_Fittable(40)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[5] == Foo_Fittable(50)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[6] == Foo_Fittable(60)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[7] == Foo_Fittable(70)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[8] == Foo_Fittable(80)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[9] == Foo_Fittable(90)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[10] == Foo_Fittable(100)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[11] == Foo_Fittable(110)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[12] == Foo_Fittable(120)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[13] == Foo_Fittable(130)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[14] == Foo_Fittable(140)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[15] == Foo_Fittable(150)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[16] == Foo_Fittable(160)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[17] == Foo_Fittable(170)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[18] == Foo_Fittable(180)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[19] == Foo_Fittable(190)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[20] == Foo_Fittable(200)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[21] == Foo_Fittable(210)
Test.@test mm_flat_on_creation_in_multiple_steps_from_all_primitives[22] == Foo_Fittable(220)
