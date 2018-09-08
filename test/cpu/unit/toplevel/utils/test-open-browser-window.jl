##### Beginning of file

import Test
import PredictMD

Test.@test_warn(
    "no filename to open",
    PredictMD.open_browser_window(nothing)
    )

##### End of file
