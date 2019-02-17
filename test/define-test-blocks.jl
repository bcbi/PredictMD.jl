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
struct TestBlockIntegration5 <: AbstractTestBlock
end
struct TestBlockIntegration6 <: AbstractTestBlock
end
struct TestBlockIntegration7 <: AbstractTestBlock
end

group_includes_block(::AbstractTestGroup, ::AbstractTestBlock) = true

group_includes_block(::TestGroupTravis1, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration6) = false
group_includes_block(::TestGroupTravis1, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis2, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration6) = false
group_includes_block(::TestGroupTravis2, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis3, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration6) = false
group_includes_block(::TestGroupTravis3, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis4, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration6) = false
group_includes_block(::TestGroupTravis4, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis5, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis5, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis5, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis5, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis5, ::TestBlockIntegration6) = false
group_includes_block(::TestGroupTravis5, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis6, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis6, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis6, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis6, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis6, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis6, ::TestBlockIntegration7) = false

group_includes_block(::TestGroupTravis7, ::TestBlockIntegration1) = false
group_includes_block(::TestGroupTravis7, ::TestBlockIntegration2) = false
group_includes_block(::TestGroupTravis7, ::TestBlockIntegration3) = false
group_includes_block(::TestGroupTravis7, ::TestBlockIntegration4) = false
group_includes_block(::TestGroupTravis7, ::TestBlockIntegration5) = false
group_includes_block(::TestGroupTravis7, ::TestBlockIntegration6) = false

##### End of file
