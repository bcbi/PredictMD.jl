##### Beginning of file

import Requires

"""
"""
has_clang() = false

Requires.@require Clang begin
    import Clang

    has_clang() = true
end

##### End of file
