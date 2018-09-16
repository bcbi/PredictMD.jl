##### Beginning of file

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

@info(
    string(
        "PREDICTMD_TEST_PLOTS: \"",
        ENV["PREDICTMD_TEST_PLOTS"],
        "\"",
        )
    )

##### End of file
