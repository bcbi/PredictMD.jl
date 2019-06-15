_ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED = false
_ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS = Dict{String, Int}()
_SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME = Dict{Int, String}()
_SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES = Dict{Int, String}()

function remove_all_full_stops(x::AbstractString)::String
    result = replace(x, "." => "")
    return result
end

function parse_icd_icd9_ccs_appendixasingledx_file!()::Nothing
    if _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED
    else
        filename = package_directory(
            "assets",
            "icd",
            "icd9",
            "ccs",
            "AppendixASingleDX.txt"
            )
        file_contents = readstring(filename)
        file_contents = strip(file_contents)
        file_sections = split(file_contents, "\n\n")
        for section in file_sections
            if startswith(section, "Appendix")
            elseif startswith(section, "Revised")
            else
                section_pieces = split(section)
                ccs_number = parse(Int, section_pieces[1])
                ccs_name = section_pieces[2]
                _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME[ccs_number] =
                    ccs_name
                icd9_code_list = section_pieces[3:end]
                icd9_code_list = [
                    convert(String, strip(x)) for x in icd9_code_list
                    ]
                icd9_code_list = convert(Vector{String}, icd9_code_list)
                _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES[ccs_number] =
                    icd9_code_list
                for icd9_code in icd9_code_list
                    _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS[icd9_code] =
                        ccs_number
                end
            end
        end
        _ICD_ICD9_CCS_APPENDIXASINGLEDX_FILE_HAS_BEEN_PARSED = true
    end
    return nothing
end

function single_level_dx_ccs_number_to_name(
        ccs_number::Int,
        )::String
    parse_icd_icd9_ccs_appendixasingledx_file!()
    result = _SINGLE_LEVEL_DX_CCS_NUMBER_TO_NAME[ccs_number]
    return result
end

function single_level_dx_ccs_to_list_of_icd9_codes(
        ccs_number::Int,
        )::Vector{String}
    parse_icd_icd9_ccs_appendixasingledx_file!()
    result = _SINGLE_LEVEL_DX_CCS_TO_LIST_OF_ICD9_CODES[ccs_number]
    return result
end

"""
"""
function icd9_code_to_single_level_dx_ccs(
        icd9_code::AbstractString,
        )::Int
    parse_icd_icd9_ccs_appendixasingledx_file!()
    result = _ICD9_CODE_TO_SINGLE_LEVEL_DX_CCS[
        remove_all_full_stops(string(icd9_code))
        ]
    return result
end

