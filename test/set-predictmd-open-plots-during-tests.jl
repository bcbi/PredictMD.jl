if length(
        lowercase(strip(get(ENV, "PREDICTMD_OPEN_PLOTS_DURING_TESTS", "")))
        ) == 0
    ENV["PREDICTMD_OPEN_PLOTS_DURING_TESTS"] = "false"
end

@info(
    string(
        "PREDICTMD_OPEN_PLOTS_DURING_TESTS: \"",
        ENV["PREDICTMD_OPEN_PLOTS_DURING_TESTS"],
        "\"",
        )
    )

