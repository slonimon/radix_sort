clc;
clear;

%%  Radix Sort Ref Model %
% Input data
mod = 2; % 0 - max, 1 - min, 2 - min and max

Q = 10;
M = 5; 
N = 3;
W = 2;
y_out = zeros(W, N);
y_out_disp = zeros(W, N);
% i_chi = [1 1 1 0; 1 0 1 0; 0 0 0 0; 0 1 1 0];
ref_test_data_max_in_3d = zeros(M, N, Q);
ref_test_data_max_out_3d = zeros(W, N, Q);
ref_test_data_min_in_3d = zeros(M, N, Q);
ref_test_data_min_out_3d = zeros(W, N, Q);

for q = 1 : 1 : Q

    i_chi = randi([0, 1], M, N);
    
    if mod == 0
            [y_out_disp, y_out, o_chi, o_chi_ij_modif] = radix_sort_max_function(M, N, W, i_chi); 
        elseif mod == 1
            [y_out_disp, y_out, o_chi, o_chi_ij_modif] = radix_sort_min_function(M, N, W, i_chi);
        elseif mod == 2
            [y_out_disp_min, y_out_min, o_chi_min, o_chi_ij_modif_min] = radix_sort_min_function(M, N, W, i_chi);
            [y_out_disp_max, y_out_max, o_chi_max, o_chi_ij_modif_max] = radix_sort_max_function(M, N, W, i_chi);
    
        for n = W : -1 : 1
            k = W - (n-1);
            y_out_disp_min_2_max(n, :) = y_out_disp_min(k, :);
        end
    
        out_y_compare = isequal(y_out_disp_min_2_max, y_out_disp_max);
    end

    ref_test_data_min_in_3d(:, :, q) = i_chi;
    ref_test_data_min_out_3d(:, :, q) = y_out_disp_min;
    ref_test_data_max_in_3d(:, :, q) = i_chi;
    ref_test_data_max_out_3d(:, :, q) = y_out_disp_max;
end
    
    ref_test_data_min_in_2d = reshape(permute(ref_test_data_min_in_3d, [3, 1, 2]), Q, N*M);
    ref_test_data_max_in_2d = reshape(permute(ref_test_data_max_in_3d, [3, 1, 2]), Q, N*M);
    ref_test_data_min_out_2d = reshape(permute(ref_test_data_min_out_3d, [3, 1, 2]), Q, N*W);
    ref_test_data_max_out_2d = reshape(permute(ref_test_data_max_out_3d, [3, 1, 2]), Q, N*W);


    ref_test_data_max_in = num2str(ref_test_data_max_in_2d, '%d');
    ref_test_data_min_out = num2str(ref_test_data_min_out_2d, '%d');
    ref_test_data_min_in = num2str(ref_test_data_min_in_2d, '%d');
    ref_test_data_max_out = num2str(ref_test_data_max_out_2d, '%d');
    
    writematrix(ref_test_data_max_in, 'ref_test_data_max_in.txt');
    writematrix(ref_test_data_max_out, 'ref_test_data_max_out.txt');
    writematrix(ref_test_data_min_in, 'ref_test_data_min_in.txt');
    writematrix(ref_test_data_min_out, 'ref_test_data_min_out.txt');
