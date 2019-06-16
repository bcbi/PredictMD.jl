import Test
import PredictMD

y_true = [3, -0.5, 2, 7,]
y_pred = [2.5, 0.0, 2, 8,]
Test.@test(
    isapprox(
        PredictMD.r2_score(y_true, y_pred,),
        0.948;
        atol = 0.001,
        )
    )

y_true = [1,2,3,]
y_pred = [1,2,3,]
Test.@test(
    isapprox(
        PredictMD.r2_score(y_true, y_pred,),
        1.0;
        )
    )

y_true = [1,2,3,]
y_pred = [2,2,2,]
Test.@test(
    isapprox(
        PredictMD.r2_score(y_true, y_pred,),
        0.0;
        )
    )

y_true = [1,2,3,]
y_pred = [3,2,1,]
Test.@test(
    isapprox(
        PredictMD.r2_score(y_true, y_pred,),
        -3.0;
        )
    )

