if length(lowercase(strip(get(ENV, "PREDICTMD_TEST_PLOTS", "")))) == 0
    ENV["PREDICTMD_TEST_PLOTS"] = "false"
end

if isa(TEST_GROUP, TestGroupAll)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end

if isa(TEST_GROUP, TestGroupTestPlots)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end

if isa(TEST_GROUP, TestGroupTravis1)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupTravis2)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupTravis3)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupTravis4)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupTravis5)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupTravis6)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end

if isa(TEST_GROUP, TestGroupDocker1)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupDocker2)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupDocker3)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end
if isa(TEST_GROUP, TestGroupDocker4)
    ENV["PREDICTMD_TEST_PLOTS"] = "true"
end

@debug(
    string(
        "PREDICTMD_TEST_PLOTS: \"",
        ENV["PREDICTMD_TEST_PLOTS"],
        "\"",
        )
    )
