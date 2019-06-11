import Test
import PredictMD

a = PredictMD.version()
Test.@test( typeof(a) == VersionNumber )
Test.@test( typeof(a) === VersionNumber )
Test.@test( a != VersionNumber(0) )
Test.@test( a > VersionNumber(0) )
Test.@test( a > VersionNumber("0.1.0") )
Test.@test( a < VersionNumber("123456789.0.0") )

