##### Beginning of file

import Requires

"""
"""
has_cxx() = false

Requires.@require Cxx begin
    import Cxx

    has_cxx() = true
end

##### End of file
