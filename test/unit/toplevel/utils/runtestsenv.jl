import PredictMD
import Test

Test.@test PredictMD.is_make_examples() isa Bool
Test.@test PredictMD.is_make_docs() isa Bool
Test.@test PredictMD.is_deploy_docs() isa Bool
Test.@test PredictMD.is_docs_or_examples() == PredictMD.is_make_examples() ||
    PredictMD.is_make_docs() ||
    PredictMD.is_deploy_docs()
