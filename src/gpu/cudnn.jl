import Requires

has_cudnn() = false

Requires.@require CUDNN begin
    has_cudnn() = true
end
