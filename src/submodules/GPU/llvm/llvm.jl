##### Beginning of file

import Requires

"""
"""
has_llvm() = false

Requires.@require LLVM begin
    import LLVM

    has_llvm() = true
end

##### End of file
