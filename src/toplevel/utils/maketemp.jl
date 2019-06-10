function maketempdir()::String
    path::String = mktempdir()
    atexit(() -> rm(path; force = true, recursive = true,))
    return path
end
