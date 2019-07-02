const _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED = Ref(false)
const _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS = Ref(Dict{String, Int}())
const _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME = Ref(Dict{Int, String}())
const _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES = Ref(Dict{Int, Vector{String}}())

function remove_all_full_stops(x::AbstractString)::String
    result = replace(x, "." => "")
    return result
end

function parse_icd_icd9_ccs_appendixasingledx_file!()::Nothing
    global _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED
    global _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS
    global _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME
    global _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES
    if _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED[]
    else
        filename = package_directory(
            "assets",
            "icd",
            "icd9",
            "ccs",
            "AppendixASingleDX.txt"
            )
        file_sections = strip.(split(strip(read(filename, String)), "\n\n"))
        for section in file_sections
            if isempty(section)
            elseif startswith(section, "Appendix")
            elseif startswith(section, "Revised")
            else
                ccs_number::Int = parse(
                    Int,
                    strip.(
                        split(strip(section))
                        )[1],
                    )
                ccs_name::String = strip(
                    join(
                        strip.(
                            split(
                                strip(
                                    split(strip(section), "\n")[1]
                                    )
                                )[2:end]
                            ), " "
                        )
                    )
                _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME[][ccs_number] = ccs_name
                icd9_code_list::Vector{String} = strip.(
                    remove_all_full_stops.(
                        split(
                            strip(
                                split(strip(section), "\n")[2]
                            )
                        )
                        )
                    )
                _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES[][
                    ccs_number
                    ] = icd9_code_list
                for icd9_code in icd9_code_list
                    _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS[][icd9_code] = ccs_number
                end
            end
        end
        _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED[] = true
    end
    return nothing
end

function single_level_dx_ccs_number_to_name(
        ccs_number::Int,
        )::String
    parse_icd_icd9_ccs_appendixasingledx_file!()
    global _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME
    result = _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME[][ccs_number]
    return result
end

function single_level_dx_ccs_to_list_of_icd9_codes(
        ccs_number::Int,
        )::Vector{String}
    parse_icd_icd9_ccs_appendixasingledx_file!()
    global _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES
    result = _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES[][ccs_number]
    return result
end

"""
"""
function icd9_code_to_single_level_dx_ccs(
        icd9_code::AbstractString,
        )::Int
    parse_icd_icd9_ccs_appendixasingledx_file!()
    global _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS
    result = _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS[][
        remove_all_full_stops(string(icd9_code))
        ]
    return result
end
