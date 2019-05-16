##### Beginning of file

import Requires

const _predictmd_has_MLJ = Ref(false)
const _predictmd_has_MLJBase = Ref(false)
const _predictmd_has_MLJModels = Ref(false)

function __init__()::Nothing
    predictmd_glue_modules_directory = joinpath(
        dirname(@__FILE__),
        "predictmd_glue_modules",
        )
    predictmd_glue_modules_list = String[
        "PredictMDGlueMLJ",
        ]
    for glue_module_name in predictmd_glue_modules_list
        pushfirst!(
            Base.LOAD_PATH,
            joinpath(
                predictmd_glue_modules_directory,
                glue_module_name,
                ),
            )
    end
    unique!(Base.LOAD_PATH,)

    Requires.@require MLJ="add582a8-e3ab-11e8-2d5e-e98b27df1bc7" begin
        global _predictmd_has_MLJ
        _predictmd_has_MLJ[] = true
        if _predictmd_has_MLJ[] &&
                _predictmd_has_MLJBase[] &&
                _predictmd_has_MLJModels[]
            import PredictMDGlueMLJ
        end
    end

    Requires.@require MLJBase="a7f614a8-145f-11e9-1d2a-a57a1082229d" begin
        global _predictmd_has_MLJBase
        _predictmd_has_MLJBase[] = true
        if _predictmd_has_MLJ[] &&
                _predictmd_has_MLJBase[] &&
                _predictmd_has_MLJModels[]
            import PredictMDGlueMLJ
        end
    end

    Requires.@require MLJModels="d491faf4-2d78-11e9-2867-c94bc002c0b7" begin
        global _predictmd_has_MLJModels
        _predictmd_has_MLJModels[] = true
        if _predictmd_has_MLJ[] &&
                _predictmd_has_MLJBase[] &&
                _predictmd_has_MLJModels[]
            import PredictMDGlueMLJ
        end
    end

    _print_welcome_message()
    return nothing
end

##### End of file
