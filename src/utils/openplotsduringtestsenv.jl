function openplotsduringtests(a::Associative)
    result =
        lowercase(get(a, "OPENPLOTSDURINGTESTS", "")) == lowercase("true")
    return result
end
