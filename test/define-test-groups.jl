##### Beginning of file

import PredictMD

abstract type AbstractTestGroup
end

struct TestGroupDefault <: AbstractTestGroup
end

struct TestGroupAll <: AbstractTestGroup
end

struct TestGroupTestPlots <: AbstractTestGroup
end

struct TestGroupTravis1 <: AbstractTestGroup
end

struct TestGroupAppVeyor1 <: AbstractTestGroup
end

const TEST_GROUP_STRING_TO_INSTANCE = Dict{String, AbstractTestGroup}(
    "default" => TestGroupDefault(),
    "all" => TestGroupAll(),
    "test-plots" => TestGroupTestPlots(),
    "travis-1" => TestGroupTravis1(),
    "appveyor-1" => TestGroupAppVeyor1(),
    )

const TEST_GROUP_INSTANCE_TO_STRING = PredictMD.inverse(
    TEST_GROUP_STRING_TO_INSTANCE
    )

##### End of file
