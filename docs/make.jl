##### Beginning of file

import Documenter
import Literate
import PredictMD

srand(999)

rm(
      joinpath(
            get_temp_directory(),
            "make_docs",
            );
      force = true,
      recursive = true,
      )

temp_makedocs_dir = joinpath(
      get_temp_directory(),
      "make_docs",
      "PredictMDTEMP",
      "docs",
      )

PredictMD.generate_docs(temp_makedocs_dir)

##### End of file
