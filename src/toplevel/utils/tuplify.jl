##### Beginning of file

"""
"""
function tuplify end

tuplify(x::Any)::Tuple = (fix_type(x),)

tuplify(x::Tuple)::Tuple = fix_type(x)

##### End of file
