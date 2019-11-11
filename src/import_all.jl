macro import_all()
    return _import_all_macro()
end

function _import_all_macro()
    statements_1 = _import_all_statements()
    pkg_list::Vector{String} = convert(Vector{String}, sort(unique(strip.(package_list()))))::Vector{String}
    n = length(pkg_list)
    statements_2 = Vector{String}(undef, n)
    for i = 1:n
        pkgname = pkg_list[i]
        statements_2[i] = "import $(pkgname)"
    end
    statements = vcat(statements_1, statements_2)
    ex = Base.Meta.parse(join(statements, "; "))
    return ex
end

function _import_all_statements()::Vector{String}
    statements = Vector{String}(undef, 0)
    _import_all_statements!(statements)
    return statements
end

function _import_all_statements!(statements::Vector{String})::Vector{String}
    pkg_list::Vector{String} = convert(Vector{String}, sort(unique(strip.(package_list()))))::Vector{String}
    for p in pkg_list
        a = string("try ",
                   "    import $(string(p)); ",
                   "catch e1 ",
                   "    @debug(\"ignoring exception: \", e1,); ",
                   "    try ",
                   "        import Pkg; ",
                   "        Pkg.add(\"$(string(p))\"); ",
                   "    catch e2 ",
                   "        @debug(\"ignoring exception: \", e2,); ",
                   "    end ",
                   "end ")
        b = string("try ",
                   "    import $(string(p)); ",
                   "    @debug(\"imported $(string(p))\"); ",
                   "catch e3 ",
                   "    @error(\"ignoring exception: \", exception=e3,); ",
                   "end ")
        push!(statements, a)
        push!(statements, b)
    end
    return statements
end

import_all() = import_all(Main)

function import_all(m::Module)::Nothing
    statements = _import_all_statements()
    for stmt in statements
        ex = Base.Meta.parse(stmt)
        Base.eval(m, ex)
    end
    return nothing
end
