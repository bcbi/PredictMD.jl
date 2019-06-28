import PredictMD
import Test

tmpdir = PredictMD.maketempdir()
tmpfile = joinpath(tmpdir, "Project.toml")
Test.@test_throws(ErrorException, PredictMD.TomlFile(tmpfile))
