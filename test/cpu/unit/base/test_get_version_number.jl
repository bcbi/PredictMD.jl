##### Beginning of file

import Base.Test
import PredictMD

a = PredictMD.version()
Base.Test.@test( typeof(a) == VersionNumber )
Base.Test.@test( typeof(a) === VersionNumber )
Base.Test.@test( a != VersionNumber(0) )
Base.Test.@test( a > VersionNumber(0) )
Base.Test.@test( a > VersionNumber("0.1.0") )
Base.Test.@test( a < VersionNumber("123456789.0.0") )

##### End of file
