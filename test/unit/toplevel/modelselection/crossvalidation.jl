Test.@testset "CrossValidation" begin
    Test.@testset "get_number_in_each_fold" begin
        Test.@test( sum(get_number_in_each_fold(100, 1)) == 100 )
        Test.@test( get_number_in_each_fold(100, 1) == [100] )
        Test.@test( sum(get_number_in_each_fold(100, 2)) == 100 )
        Test.@test( get_number_in_each_fold(100, 2) == [50, 50] )
        Test.@test( sum(get_number_in_each_fold(100, 3)) == 100 )
        Test.@test( get_number_in_each_fold(100, 3) == [34, 33, 33] )
        Test.@test( sum(get_number_in_each_fold(100, 4)) == 100 )
        Test.@test( get_number_in_each_fold(100, 4) == [25, 25, 25, 25] )
        Test.@test( sum(get_number_in_each_fold(100, 5)) == 100 )
        Test.@test( get_number_in_each_fold(100, 5) == [20, 20, 20, 20, 20] )
        Test.@test( sum(get_number_in_each_fold(100, 6)) == 100 )
        Test.@test( get_number_in_each_fold(100, 6) == [17, 17, 17, 17, 16, 16] )
        Test.@test( sum(get_number_in_each_fold(100, 7)) == 100 )
        Test.@test( get_number_in_each_fold(100, 7) == [15, 15, 14, 14, 14, 14, 14] )
        Test.@test( sum(get_number_in_each_fold(100, 8)) == 100 )
        Test.@test( get_number_in_each_fold(100, 8) == [13, 13, 13, 13, 12, 12, 12, 12] )
        Test.@test( sum(get_number_in_each_fold(100, 9)) == 100 )
        Test.@test( get_number_in_each_fold(100, 9) == [12, 11, 11, 11, 11, 11, 11, 11, 11] )
        Test.@test( sum(get_number_in_each_fold(100, 10)) == 100 )
        Test.@test( get_number_in_each_fold(100, 10) == [10, 10, 10, 10, 10, 10, 10, 10, 10, 10] )
    end

    Test.@testset "get_indices_in_each_fold" begin
        Test.@test( get_indices_in_each_fold([1,2,3,4,5,6,7,8,9,10], 3) == [[1,2,3,4], [5,6,7], [8,9,10]] )
        Test.@test( get_indices_in_each_fold([5,6,7,8,9,10], 3) == [[5,6], [7,8], [9,10]] )
        Test.@test( get_indices_in_each_fold([1,2,3,4,8,9,10], 3) == [[1,2,3], [4,8], [9,10]] )
        Test.@test( get_indices_in_each_fold([1,2,3,4,5,6,7], 3) == [[1,2,3], [4,5], [6,7]] )
    end

    Test.@testset "get_leavein_indices on vector of integers" begin
        Test.@test( get_leavein_indices([1,2,3,4,5,6,7,8,9,10], 3, 1) == [5,6,7,8,9,10] )
        Test.@test( get_leavein_indices([1,2,3,4,5,6,7,8,9,10], 3, 2) == [1,2,3,4,8,9,10] )
        Test.@test( get_leavein_indices([1,2,3,4,5,6,7,8,9,10], 3, 3) == [1,2,3,4,5,6,7] )
    end

    Test.@testset "get_leaveout_indices on vector of integers" begin
        Test.@test( get_leaveout_indices([1,2,3,4,5,6,7,8,9,10], 3, 1) == [1,2,3,4] )
        Test.@test( get_leaveout_indices([1,2,3,4,5,6,7,8,9,10], 3, 2) == [5,6,7] )
        Test.@test( get_leaveout_indices([1,2,3,4,5,6,7,8,9,10], 3, 3) == [8,9,10] )
    end

    Test.@testset "nested cross validation, integer indices, small" begin
        cv = CrossValidation{Int}(; all_indices = [1,2,3,4,5,6,7,8,9,10], num_folds_per_level = (2,2,2))
        Test.@test( isa(cv, CrossValidation{Int}) )
        Test.@test( !isleaf(cv) )
        Test.@test( get_top_level_num_folds(cv) == 2 )
        Test.@test( get_leaveout_indices(cv, 1) == [1,2,3,4,5] )
        Test.@test( get_leaveout_indices(cv, 2) == [6,7,8,9,10] )
        Test.@test_throws( ArgumentError, get_leavein_indices(cv) )

        cv_1 = get_leavein_cv(cv, 1)
        Test.@test( !isleaf(cv_1) )
        Test.@test( get_top_level_num_folds(cv_1) == 2 )
        Test.@test( get_leaveout_indices(cv_1, 1) == [6,7,8] )
        Test.@test( get_leaveout_indices(cv_1, 2) == [9,10] )
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1) )

        cv_2 = get_leavein_cv(cv, 2)
        Test.@test( !isleaf(cv_2) )
        Test.@test( get_top_level_num_folds(cv_2) == 2 )
        Test.@test( get_leaveout_indices(cv_2, 1) ==  [1,2,3])
        Test.@test( get_leaveout_indices(cv_2, 2) ==  [4,5])
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2) )

        cv_1_1 = get_leavein_cv(cv_1, 1)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1_1) )
        Test.@test( !isleaf(cv_1_1) )
        Test.@test( get_top_level_num_folds(cv_1_1) == 2 )
        Test.@test( get_leaveout_indices(cv_1_1, 1) == [9] )
        Test.@test( get_leaveout_indices(cv_1_1, 2) == [10] )

        cv_1_2 = get_leavein_cv(cv_1, 2)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1_2) )
        Test.@test( !isleaf(cv_1_2) )
        Test.@test( get_top_level_num_folds(cv_1_2) == 2 )
        Test.@test( get_leaveout_indices(cv_1_2, 1) == [6, 7] )
        Test.@test( get_leaveout_indices(cv_1_2, 2) == [8] )

        cv_2_1 = get_leavein_cv(cv_2, 1)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2_1) )
        Test.@test( !isleaf(cv_2_1) )
        Test.@test( get_top_level_num_folds(cv_2_1) == 2 )
        Test.@test( get_leaveout_indices(cv_2_1, 1) == [4] )
        Test.@test( get_leaveout_indices(cv_2_1, 2) == [5] )

        cv_2_2 = get_leavein_cv(cv_2, 2)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2_2) )
        Test.@test( !isleaf(cv_2_2) )
        Test.@test( get_top_level_num_folds(cv_2_2) == 2 )
        Test.@test( get_leaveout_indices(cv_2_2, 1) == [1,2] )
        Test.@test( get_leaveout_indices(cv_2_2, 2) == [3] )

        cv_1_1_1 = get_leavein_cv(cv_1_1, 1)
        Test.@test( isleaf(cv_1_1_1) )
        Test.@test( get_top_level_num_folds(cv_1_1_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_1_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_1_1, 1) )
        Test.@test( get_leavein_indices(cv_1_1_1) == [10] )

        cv_1_1_2 = get_leavein_cv(cv_1_1, 2)
        Test.@test( isleaf(cv_1_1_2) )
        Test.@test( get_top_level_num_folds(cv_1_1_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_1_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_1_2, 1) )
        Test.@test( get_leavein_indices(cv_1_1_2) == [9] )

        cv_1_2_1 = get_leavein_cv(cv_1_2, 1)
        Test.@test( isleaf(cv_1_2_1) )
        Test.@test( get_top_level_num_folds(cv_1_2_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_2_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_2_1, 1) )
        Test.@test( get_leavein_indices(cv_1_2_1) == [8] )

        cv_1_2_2 = get_leavein_cv(cv_1_2, 2)
        Test.@test( isleaf(cv_1_2_2) )
        Test.@test( get_top_level_num_folds(cv_1_2_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_2_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_2_2, 1) )
        Test.@test( get_leavein_indices(cv_1_2_2) == [6,7] )

        cv_2_1_1 = get_leavein_cv(cv_2_1, 1)
        Test.@test( isleaf(cv_2_1_1) )
        Test.@test( get_top_level_num_folds(cv_2_1_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_1_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_1_1, 1) )
        Test.@test( get_leavein_indices(cv_2_1_1) == [5] )

        cv_2_1_2 = get_leavein_cv(cv_2_1, 2)
        Test.@test( isleaf(cv_2_1_2) )
        Test.@test( get_top_level_num_folds(cv_2_1_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_1_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_1_2, 1) )
        Test.@test( get_leavein_indices(cv_2_1_2) == [4] )

        cv_2_2_1 = get_leavein_cv(cv_2_2, 1)
        Test.@test( isleaf(cv_2_2_1) )
        Test.@test( get_top_level_num_folds(cv_2_2_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_2_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_2_1, 1) )
        Test.@test( get_leavein_indices(cv_2_2_1) == [3] )

        cv_2_2_2 = get_leavein_cv(cv_2_2, 2)
        Test.@test( isleaf(cv_2_2_2) )
        Test.@test( get_top_level_num_folds(cv_2_2_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_2_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_2_2, 1) )
        Test.@test( get_leavein_indices(cv_2_2_2) == [1,2] )
    end

    Test.@testset "nested cross validation, range indices, small" begin
        cv_integers = CrossValidation{Int}(; all_indices = [1,2,3,4,5,6,7,8,9,10], num_folds_per_level = (2,2,2))
        Test.@test( isa(cv_integers, CrossValidation{Int}) )
        cv_ranges = CrossValidation{UnitRange{Int}}(cv_integers)
        Test.@test( isa(cv_ranges, CrossValidation{UnitRange{Int}}) )
        Test.@test( !isleaf(cv_ranges) )
        Test.@test( get_top_level_num_folds(cv_ranges) == 2 )
        Test.@test( get_leaveout_indices(cv_ranges, 1) == [1:5] )
        Test.@test( get_leaveout_indices(cv_ranges, 2) == [6:10] )
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_ranges) )

        cv_1 = get_leavein_cv(cv_ranges, 1)
        Test.@test( !isleaf(cv_1) )
        Test.@test( get_top_level_num_folds(cv_1) == 2 )
        Test.@test( get_leaveout_indices(cv_1, 1) == [6:8] )
        Test.@test( get_leaveout_indices(cv_1, 2) == [9:10] )
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1) )

        cv_2 = get_leavein_cv(cv_ranges, 2)
        Test.@test( !isleaf(cv_2) )
        Test.@test( get_top_level_num_folds(cv_2) == 2 )
        Test.@test( get_leaveout_indices(cv_2, 1) ==  [1:3])
        Test.@test( get_leaveout_indices(cv_2, 2) ==  [4:5])
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2) )

        cv_1_1 = get_leavein_cv(cv_1, 1)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1_1) )
        Test.@test( !isleaf(cv_1_1) )
        Test.@test( get_top_level_num_folds(cv_1_1) == 2 )
        Test.@test( get_leaveout_indices(cv_1_1, 1) == [9:9] )
        Test.@test( get_leaveout_indices(cv_1_1, 2) == [10:10] )

        cv_1_2 = get_leavein_cv(cv_1, 2)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_1_2) )
        Test.@test( !isleaf(cv_1_2) )
        Test.@test( get_top_level_num_folds(cv_1_2) == 2 )
        Test.@test( get_leaveout_indices(cv_1_2, 1) == [6:7] )
        Test.@test( get_leaveout_indices(cv_1_2, 2) == [8:8] )

        cv_2_1 = get_leavein_cv(cv_2, 1)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2_1) )
        Test.@test( !isleaf(cv_2_1) )
        Test.@test( get_top_level_num_folds(cv_2_1) == 2 )
        Test.@test( get_leaveout_indices(cv_2_1, 1) == [4:4] )
        Test.@test( get_leaveout_indices(cv_2_1, 2) == [5:5] )

        cv_2_2 = get_leavein_cv(cv_2, 2)
        Test.@test_throws( ArgumentError, get_leavein_indices(cv_2_2) )
        Test.@test( !isleaf(cv_2_2) )
        Test.@test( get_top_level_num_folds(cv_2_2) == 2 )
        Test.@test( get_leaveout_indices(cv_2_2, 1) == [1:2] )
        Test.@test( get_leaveout_indices(cv_2_2, 2) == [3:3] )

        cv_1_1_1 = get_leavein_cv(cv_1_1, 1)
        Test.@test( isleaf(cv_1_1_1) )
        Test.@test( get_top_level_num_folds(cv_1_1_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_1_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_1_1, 1) )
        Test.@test( get_leavein_indices(cv_1_1_1) == [10:10] )

        cv_1_1_2 = get_leavein_cv(cv_1_1, 2)
        Test.@test( isleaf(cv_1_1_2) )
        Test.@test( get_top_level_num_folds(cv_1_1_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_1_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_1_2, 1) )
        Test.@test( get_leavein_indices(cv_1_1_2) == [9:9] )

        cv_1_2_1 = get_leavein_cv(cv_1_2, 1)
        Test.@test( isleaf(cv_1_2_1) )
        Test.@test( get_top_level_num_folds(cv_1_2_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_2_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_2_1, 1) )
        Test.@test( get_leavein_indices(cv_1_2_1) == [8:8] )

        cv_1_2_2 = get_leavein_cv(cv_1_2, 2)
        Test.@test( isleaf(cv_1_2_2) )
        Test.@test( get_top_level_num_folds(cv_1_2_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_1_2_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_1_2_2, 1) )
        Test.@test( get_leavein_indices(cv_1_2_2) == [6:7] )

        cv_2_1_1 = get_leavein_cv(cv_2_1, 1)
        Test.@test( isleaf(cv_2_1_1) )
        Test.@test( get_top_level_num_folds(cv_2_1_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_1_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_1_1, 1) )
        Test.@test( get_leavein_indices(cv_2_1_1) == [5:5] )

        cv_2_1_2 = get_leavein_cv(cv_2_1, 2)
        Test.@test( isleaf(cv_2_1_2) )
        Test.@test( get_top_level_num_folds(cv_2_1_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_1_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_1_2, 1) )
        Test.@test( get_leavein_indices(cv_2_1_2) == [4:4] )

        cv_2_2_1 = get_leavein_cv(cv_2_2, 1)
        Test.@test( isleaf(cv_2_2_1) )
        Test.@test( get_top_level_num_folds(cv_2_2_1) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_2_1, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_2_1, 1) )
        Test.@test( get_leavein_indices(cv_2_2_1) == [3:3] )

        cv_2_2_2 = get_leavein_cv(cv_2_2, 2)
        Test.@test( isleaf(cv_2_2_2) )
        Test.@test( get_top_level_num_folds(cv_2_2_2) == 0 )
        Test.@test_throws( ArgumentError, get_leaveout_indices(cv_2_2_2, 1) )
        Test.@test_throws( ArgumentError, get_leavein_cv(cv_2_2_2, 1) )
        Test.@test( get_leavein_indices(cv_2_2_2) == [1:2] )
    end

    Test.@testset "nested cross validation, integer indices, large" begin
        num_samples = 10_000
        master_cv = CrossValidation{Int}(; all_indices = collect(1:num_samples), num_folds_per_level = (11,5,7))
        Test.@test( isa(master_cv, CrossValidation{Int}) )
        Test.@test( get_all_indices(master_cv) == 1:num_samples)
        Test.@test( !isleaf(master_cv) )
        Test.@test( get_top_level_num_folds(master_cv) == 11 )
        for i = 1:11
            testing_indices = get_leaveout_indices(master_cv, i)
            supertuning_tuning_training_cv = get_leavein_cv(master_cv, i)
            Test.@test( length(intersect(testing_indices, get_all_indices(supertuning_tuning_training_cv))) == 0 )
            Test.@test( sort(unique(union(testing_indices, get_all_indices(supertuning_tuning_training_cv)))) == 1:num_samples )
            Test.@test( !isleaf(supertuning_tuning_training_cv) )
            Test.@test( get_top_level_num_folds(supertuning_tuning_training_cv) == 5 )
            for j = 1:5
                supertuning_indices = get_leaveout_indices(supertuning_tuning_training_cv, j)
                tuning_training_cv = get_leavein_cv(supertuning_tuning_training_cv, j)
                Test.@test( !isleaf(tuning_training_cv) )
                Test.@test( get_top_level_num_folds(tuning_training_cv) == 7 )
                for k = 1:7
                    tuning_indices = get_leaveout_indices(tuning_training_cv, k)
                    training_cv = get_leavein_cv(tuning_training_cv, k)
                    Test.@test( isleaf(training_cv) )
                    Test.@test( get_top_level_num_folds(training_cv) == 0 )
                    training_indices = get_leavein_indices(training_cv)
                    Test.@test( length(intersect(testing_indices, supertuning_indices)) == 0 )
                    Test.@test( length(intersect(testing_indices, tuning_indices)) == 0 )
                    Test.@test( length(intersect(testing_indices, training_indices)) == 0 )
                    Test.@test( length(intersect(supertuning_indices, tuning_indices)) == 0 )
                    Test.@test( length(intersect(supertuning_indices, training_indices)) == 0 )
                    Test.@test( length(intersect(tuning_indices, training_indices)) == 0 )
                end
            end
        end
    end

    Test.@testset "nested cross validation, range indices, large" begin
        num_samples = 10_000
        master_cv_integers = CrossValidation{Int}(; all_indices = collect(1:num_samples), num_folds_per_level = (11,5,7))
        Test.@test( isa(master_cv_integers, CrossValidation{Int}) )
        master_cv_ranges = CrossValidation{UnitRange{Int}}(master_cv_integers)
        Test.@test( isa(master_cv_ranges, CrossValidation{UnitRange{Int}}) )
        Test.@test( !isleaf(master_cv_ranges) )
        Test.@test( get_top_level_num_folds(master_cv_ranges) == 11 )
        for i = 1:11
            testing_indices = get_leaveout_indices(master_cv_ranges, i)
            supertuning_tuning_training_cv = get_leavein_cv(master_cv_ranges, i)
            Test.@test( !isleaf(supertuning_tuning_training_cv) )
            Test.@test( get_top_level_num_folds(supertuning_tuning_training_cv) == 5 )
            for j = 1:5
                supertuning_indices = get_leaveout_indices(supertuning_tuning_training_cv, j)
                tuning_training_cv = get_leavein_cv(supertuning_tuning_training_cv, j)
                Test.@test( !isleaf(tuning_training_cv) )
                Test.@test( get_top_level_num_folds(tuning_training_cv) == 7 )
                for k = 1:7
                    tuning_indices = get_leaveout_indices(tuning_training_cv, k)
                    training_cv = get_leavein_cv(tuning_training_cv, k)
                    Test.@test( isleaf(training_cv) )
                    Test.@test( get_top_level_num_folds(training_cv) == 0 )
                    training_indices = get_leavein_indices(training_cv)
                    Test.@test( length(intersect(testing_indices, supertuning_indices)) == 0 )
                    Test.@test( length(intersect(testing_indices, tuning_indices)) == 0 )
                    Test.@test( length(intersect(testing_indices, training_indices)) == 0 )
                    Test.@test( length(intersect(supertuning_indices, tuning_indices)) == 0 )
                    Test.@test( length(intersect(supertuning_indices, training_indices)) == 0 )
                    Test.@test( length(intersect(tuning_indices, training_indices)) == 0 )
                end
            end
        end
    end

    Test.@testset "roundtrip CV integer indices <-> CV range indices" begin
        num_samples = 10_000
        cv_integer_1 = CrossValidation{Int}(; all_indices = collect(1:num_samples), num_folds_per_level = (11,5,7))
        cv_ranges_2 = CrossValidation{UnitRange{Int}}(cv_integer_1)
        cv_integer_3 = CrossValidation{Int}(cv_ranges_2)
        cv_ranges_4 = CrossValidation{UnitRange{Int}}(cv_integer_3)
        cv_integer_5 = CrossValidation{Int}(cv_ranges_4)
        cv_ranges_6 = CrossValidation{UnitRange{Int}}(cv_integer_5)
        cv_integer_7 = CrossValidation{Int}(cv_ranges_6)
        cv_ranges_8 = CrossValidation{UnitRange{Int}}(cv_integer_7)
        cv_integer_9 = CrossValidation{Int}(cv_ranges_8)
        Test.@test( isa(cv_integer_1, CrossValidation{Int}) )
        Test.@test( isa(cv_integer_3, CrossValidation{Int}) )
        Test.@test( isa(cv_integer_5, CrossValidation{Int}) )
        Test.@test( isa(cv_integer_7, CrossValidation{Int}) )
        Test.@test( isa(cv_integer_9, CrossValidation{Int}) )
        Test.@test( isa(cv_ranges_2, CrossValidation{UnitRange{Int}}) )
        Test.@test( isa(cv_ranges_4, CrossValidation{UnitRange{Int}}) )
        Test.@test( isa(cv_ranges_6, CrossValidation{UnitRange{Int}}) )
        Test.@test( isa(cv_ranges_8, CrossValidation{UnitRange{Int}}) )
        Test.@test( cv_integer_1 == cv_integer_3 == cv_integer_5 == cv_integer_7 == cv_integer_9)
        Test.@test( cv_ranges_2 == cv_ranges_4 == cv_ranges_6 == cv_ranges_8)
    end

    Test.@testset "vectors_to_ranges" begin
        x = Int[
            12, 28, 27, 24, 21, 30, 6, 10, 4, 18,
            16, 36, 35, 29, 15, 9, 19, 34, 17, 5,
            23, 3, 26, 37, 20, 11, 7,
            ]
        y = UnitRange{Int}[
            3:7, 9:12, 15:21, 23:24, 26:30, 34:37,
            ]
        Test.@test y == vector_to_ranges(x)
        vector_1 = StatsBase.sample(1:100_000_000, 100_000)
        unique!(vector_1)
        sort!(vector_1)
        ranges_2 = vector_to_ranges(vector_1)
        vector_3 = ranges_to_vector(ranges_2)
        ranges_4 = vector_to_ranges(vector_3)
        vector_5 = ranges_to_vector(ranges_4)
        ranges_6 = vector_to_ranges(vector_5)
        vector_7 = ranges_to_vector(ranges_6)
        ranges_8 = vector_to_ranges(vector_7)
        vector_9 = ranges_to_vector(ranges_8)
        Test.@test vector_1 == vector_3 == vector_5 == vector_7 == vector_9
        Test.@test ranges_2 == ranges_4 == ranges_6 == ranges_8
    end

    Test.@testset "ranges_to_vectors" begin
        x = Int[
            12, 28, 27, 24, 21, 30, 6, 10, 4, 18,
            16, 36, 35, 29, 15, 9, 19, 34, 17, 5,
            23, 3, 26, 37, 20, 11, 7,
            ]
        y = UnitRange{Int}[
            3:7, 9:12, 15:21, 23:24, 26:30, 34:37,
            ]
        Test.@test sort(x) == ranges_to_vector(y)
        ranges_1 = Vector{UnitRange{Int}}(undef, 0)
        for i = 1:100
            a = StatsBase.sample((i)*(1_000_000):(i+1)*(1_000_000))
            b = StatsBase.sample((i)*(1_000_000):(i+1)*(1_000_000))
            push!(ranges_1, min(a,b):max(a,b))
        end
        unique!(ranges_1)
        sort!(ranges_1)
        vector_2 = ranges_to_vector(ranges_1)
        ranges_3 = vector_to_ranges(vector_2)
        vector_4 = ranges_to_vector(ranges_3)
        ranges_5 = vector_to_ranges(vector_4)
        vector_6 = ranges_to_vector(ranges_5)
        ranges_7 = vector_to_ranges(vector_6)
        vector_8 = ranges_to_vector(ranges_7)
        ranges_9 = vector_to_ranges(vector_8)
        Test.@test ranges_1 == ranges_3 == ranges_5 == ranges_7 == ranges_9
        Test.@test vector_2 == vector_4 == vector_6 == vector_8
    end
end
