##### Beginning of file

"""
"""
function tuplify end

tuplify(x::Any)::Tuple = (x,)

tuplify(x::Tuple)::Tuple = x

##### End of file
