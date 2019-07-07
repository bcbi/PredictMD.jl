@test_throws ErrorException PredictMD.generate_examples(PredictMD.maketempdir())
@test_throws ErrorException PredictMD.generate_examples(PredictMD.maketempdir(); scripts = true)
