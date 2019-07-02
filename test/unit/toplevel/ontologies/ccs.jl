Test.@test( PredictMD.remove_all_full_stops(".1.2.3.4.") == "1234" )
Test.@test( PredictMD.remove_all_full_stops("1234") == "1234" )

PredictMD.parse_icd_icd9_ccs_appendixasingledx_file!()
PredictMD.parse_icd_icd9_ccs_appendixasingledx_file!()
PredictMD.parse_icd_icd9_ccs_appendixasingledx_file!()

Test.@test(PredictMD.single_level_dx_ccs_number_to_name(1) == "Tuberculosis")
Test.@test(PredictMD.single_level_dx_ccs_number_to_name(2) == "Septicemia (except in labor)")

Test.@test(
    all(sort(unique(
        PredictMD.single_level_dx_ccs_to_list_of_icd9_codes(107))) .==
            sort(unique(["42741", "42742", "4275"])))
    )

Test.@test(PredictMD.icd9_code_to_single_level_dx_ccs("42741") == 107)
