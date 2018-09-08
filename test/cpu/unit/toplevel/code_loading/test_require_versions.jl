##### Beginning of file

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        [],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.2"],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.3"],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.3", "1.2.4-"],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["2.3.4", "2.3.5-", "1.2.3"],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["2.3.4", "2.3.5-", "1.2.3", "1.2.4-"],
        )
    )

Test.@test(
    PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["2.3.4", "2.3.5-", "0.1.2", "0.1.3-", "1.2.2"],
        )
    )

Test.@test(
    !PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.4"],
        )
    )

Test.@test(
    !PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.4", "1.2.5-"],
        )
    )

Test.@test(
    !PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.4", "1.2.5-", "0.1.2", "0.1.3-"],
        )
    )

Test.@test(
    !PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.4", "1.2.5-", "0.1.2", "0.1.3-", "1.2.2", "1.2.3-"],
        )
    )

Test.@test(
    !PredictMD.does_given_version_meet_requirements(
        VersionNumber("1.2.3"),
        ["1.2.4", "1.2.5-", "0.1.2", "0.1.3-", "1.2.2", "1.2.3-", "1.2.3+"],
        )
    )

##### End of file
