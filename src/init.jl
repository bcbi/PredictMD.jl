import Requires

function __init__()::Nothing
    predictmd_glue_modules_directory = joinpath(
        dirname(@__FILE__),
        "predictmd_glue_modules",
        )
    predictmd_glue_modules_list = String[
        "PredictMD_Glue_MLJ",
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
    unique!(Base.LOAD_PATH)

    Requires.@require MLJ="add582a8-e3ab-11e8-2d5e-e98b27df1bc7" begin
        Requires.@require MLJBase="a7f614a8-145f-11e9-1d2a-a57a1082229d" begin
            Requires.@require MLJModels="d491faf4-2d78-11e9-2867-c94bc002c0b7" begin
                import PredictMD_Glue_MLJ
            end
        end
    end

    print_welcome_message()
    return nothing
end
