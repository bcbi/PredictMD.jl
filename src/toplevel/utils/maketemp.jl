function maketemp(parent=tempdir())::String
    path::String = mktempdir(parent)
    atexit(() -> rm(path; force = true, recursive = true,))
    return path
end
