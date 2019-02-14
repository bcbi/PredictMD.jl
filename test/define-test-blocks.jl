##### Beginning of file

abstract type AbstractTestBlock
end

struct TestBlockUnitTests <: AbstractTestBlock
end

struct TestBlockIntegration1 <: AbstractTestBlock
end

struct TestBlockIntegration2 <: AbstractTestBlock
end

group_includes_block(::AbstractTestGroup, ::AbstractTestBlock) = true

group_includes_block(::TestGroupTravis2, ::TestBlockIntegration1) = false

group_includes_block(::TestGroupTravis1, ::TestBlockIntegration2) = false


##### End of file
