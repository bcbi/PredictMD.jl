##### Beginning of file

abstract type AbstractTestBlock
end

struct TestBlockUnitTests <: AbstractTestBlock
end
struct TestBlockIntegration1 <: AbstractTestBlock
end
struct TestBlockIntegration2 <: AbstractTestBlock
end
struct TestBlockIntegration3 <: AbstractTestBlock
end
struct TestBlockIntegration4 <: AbstractTestBlock
end

group_includes_block(::AbstractTestGroup, ::AbstractTestBlock) = true

group_includes_block(::TestGroupTravis1, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration4) = false

group_includes_block(::TestGroupTravis2, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration4) = false

group_includes_block(::TestGroupTravis3, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration4) = false

group_includes_block(::TestGroupTravis4, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration3) = false

##### End of file
