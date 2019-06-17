import PredictMD

abstract type AbstractTestGroup end

struct TestGroupDefault <: AbstractTestGroup end

struct TestGroupAll <: AbstractTestGroup end

struct TestGroupTestPlots <: AbstractTestGroup end

struct TestGroupImportOnly <: AbstractTestGroup end

struct TestGroupTravis1 <: AbstractTestGroup end
struct TestGroupTravis2 <: AbstractTestGroup end
struct TestGroupTravis3 <: AbstractTestGroup end
struct TestGroupTravis4 <: AbstractTestGroup end
struct TestGroupTravis5 <: AbstractTestGroup end
struct TestGroupTravis6 <: AbstractTestGroup end
struct TestGroupTravis7 <: AbstractTestGroup end

struct TestGroupDocker1 <: AbstractTestGroup end
struct TestGroupDocker2 <: AbstractTestGroup end
struct TestGroupDocker3 <: AbstractTestGroup end
struct TestGroupDocker4 <: AbstractTestGroup end

const TEST_GROUP_STRING_TO_INSTANCE = Dict{String, AbstractTestGroup}(
    #
    "default" => TestGroupDefault(),
    #
    "all" => TestGroupAll(),
    #
    "test-plots" => TestGroupTestPlots(),
    #
    "import-only" => TestGroupImportOnly(),
    #
    "travis-1" => TestGroupTravis1(),
    "travis-2" => TestGroupTravis2(),
    "travis-3" => TestGroupTravis3(),
    "travis-4" => TestGroupTravis4(),
    "travis-5" => TestGroupTravis5(),
    "travis-6" => TestGroupTravis6(),
    "travis-7" => TestGroupTravis7(),
    #
    "docker-1" => TestGroupDocker1(),
    "docker-2" => TestGroupDocker2(),
    "docker-3" => TestGroupDocker3(),
    "docker-4" => TestGroupDocker4(),
    )

const TEST_GROUP_INSTANCE_TO_STRING = PredictMD.inverse(
    TEST_GROUP_STRING_TO_INSTANCE
    )
