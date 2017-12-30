function istravisci(envhash::Base.EnvHash)
    if haskey(envhash, "CI")
        if envhash["CI"] == "true"
            if haskey(envhash, "")
                if envhash["TRAVIS"] == "true"
                    if haskey(envhash, "CONTINUOUS_INTEGRATION")
                        if envhash["CONTINUOUS_INTEGRATION"] == "true"
                            return true
                        else
                            return false
                        end
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end
