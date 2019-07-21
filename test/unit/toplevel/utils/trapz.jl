import PredictMD
import Test

Test.@test_throws ErrorException PredictMD.trapz([1, 2, 3], [])
Test.@test_throws ErrorException PredictMD.trapz([], [])
Test.@test_throws ErrorException PredictMD.trapz([1, 2, 1], [4, 5, 4])

x_1 = collect(0:0.00001:1)
f_1(t) = t^2
y_1 = f_1.(x_1)
I_1 = PredictMD.trapz(x_1, y_1)
Test.@test isapprox(I_1, 1/3; atol=0.00000001)

x_2 = collect(0:0.00001:1)
f_2(t) = (t^2) * (tanh(t))
y_2 = f_2.(x_2)
I_2 = PredictMD.trapz(x_2, y_2)
Test.@test isapprox(I_2, 0.207068855098706896; atol=0.00000001)
