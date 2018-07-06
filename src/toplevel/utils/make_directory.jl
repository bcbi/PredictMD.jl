##### Beginning of file

function directory(parts...)
    if is_ci_or_runtests_or_docs_or_examples() && !is_travis_ci()
        true_path = joinpath(tempdir(), "PREDICTMDTEMPDIR")
    else
        true_path = joinpath(parts...)
    end
    Base.Filesystem.mkpath(true_path)
    return true_path
end

##### End of file
