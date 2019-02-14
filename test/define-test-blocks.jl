##### Beginning of file

abstract type AbstractTestBlock
end

struct TestBlockUnitTests <: AbstractTestGroup
end

struct TestBlockIntegration1 <: AbstractTestGroup
end

struct TestBlockIntegration2 <: AbstractTestGroup
end

group_includes_block(::AbstractTestGroup, ::AbstractTestBlock) = true

group_includes_block(::TestGroupTravis2, ::TestBlockIntegration1) = false

group_includes_block(::TestGroupTravis1, ::TestBlockIntegration2) = false


##### End of file
