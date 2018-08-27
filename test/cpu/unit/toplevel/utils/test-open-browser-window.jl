##### Beginning of file

import Base.Test
import PredictMD

Base.Test.@test_warn(
    "no filename to open",
    PredictMD.open_browser_window(nothing)
    )

##### End of file
