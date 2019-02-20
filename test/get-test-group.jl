##### Beginning of file

import PredictMD

if PredictMD.is_travis_ci() && !haskey(ENV, "PREDICTMD_TEST_GROUP")
    ENV["PREDICTMD_TEST_GROUP"] = lowercase(
        strip(
            get(
                ENV,
                "GROUP",
                "",
                )
            )
        )
end

const _test_group_environment_variable = lowercase(
    strip(
        get(
            ENV,
            "PREDICTMD_TEST_GROUP",
            ""
            )
        )
    )

if length(_test_group_environment_variable) == 0
    const _test_group_value = "default"
else
    const _test_group_value = _test_group_environment_variable
end

if haskey(TEST_GROUP_STRING_TO_INSTANCE, _test_group_value)
    const TEST_GROUP = TEST_GROUP_STRING_TO_INSTANCE[_test_group_value]
    @info(
        string(
            "PREDICTMD_TEST_GROUP: \"",
            TEST_GROUP_INSTANCE_TO_STRING[TEST_GROUP],
            "\"",
            )
        )
else
    const _valid_test_group_values = string(
        "\"",
        join(
            sort(collect(keys(TEST_GROUP_STRING_TO_INSTANCE))),
            "\", \"",
            ),
        "\"",
        )
    error(
        string(
            "\"",
            _test_group_value,
            "\" is not a valid value for PREDICTMD_TEST_GROUP. ",
            "Valid values are: ",
            _valid_test_group_values,
            ".",
            )
        )
end

##### End of file
