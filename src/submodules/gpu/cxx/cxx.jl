import Requires

"""
"""
has_cxx() = false

Requires.@require Cxx begin
    has_cxx() = true
end
