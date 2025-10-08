
clc;
clear;

%%  Radix Sort Ref Model %
% max
% Input data
M = 4;
N = 4;
W = 4;
% i_chi = randi([0, 1], M, N);
i_chi = [1 1 1 0; 1 0 1 0; 0 0 0 0; 0 1 1 0];

y_out_disp = zeros(W, N);
y_out = zeros(W, N);

for w = 1 : 1 : W
    [y_out_disp(w, :), o_chi_ij_modif_disp, y_out(w, :), o_chi_ij_modif] = sort_stage(i_chi, N, M);
    i_chi = o_chi_ij_modif;
end 
%%
function [y_out_disp, o_chi_ij_modif_disp, y_out, o_chi_ij_modif] = sort_stage(i_chi, N, M)
%% H - matrix calculate

% old H-matrix
h_i_last = i_chi(:, N) & i_chi(:, N-1);
h_ij = zeros(M, N-1);
h_ij(:, N-1) =  h_i_last;

for n = N - 2 : -1 : 1
    h_ij(:, n) =  h_ij(:, n+1) & i_chi(:, n); 
end

h_ij = h_ij';

H_matrix_old = zeros(N-1, M);
for n = N-1 : -1 : 1
    k = N-1 - (n-1);
    H_matrix_old(n, :) = h_ij(k, :);
end

%% modified H-matrix

% z-calculate 
% z_j = zeros(N,1);
% z_j(1:N) =  ~any(h_ij(:, 1:N));
%% 
H_ij_modif = zeros(M,N);
for n = N : -1 : 1
    if n == N
        z_j(N) = ~any(i_chi(:, N));
        for m = M : -1 : 1
        H_ij_modif(m, N) = z_j(N) | i_chi(m, N);
        end
    elseif n < N
    for m = M : -1 : 1
        h(m, n) = H_ij_modif(m, n+1) & i_chi(m, n);  
    end   
    z_j(n) =  ~any(h(:, n));
    for m = M : -1 : 1
        H_ij_modif(m, n) =  (z_j(n) & H_ij_modif(m, n+1)) | h(m, n); 
    end
    end
end

H_ij_modif = H_ij_modif';

H_modify = zeros(N, M);
for n = N : -1 : 1
    k = N - (n-1);
    H_modify(n, :) = H_ij_modif(k, :);
end

%% output generation circuit
% selection-sell - out
xi_ij = zeros(M, N);
o_chi_ij_modif = zeros(M, N);

% selection-sell - in
i_chi_circuit = i_chi;
g_j = zeros(1, M);

% g-slice - in\out
tau_prev = zeros(1, M-1);


% calculate output generation circuit
    for m = M : -1 : 1
        if m == 1
            g_j(m) = H_ij_modif(1, m);
            [o_chi_ij_modif(m, :), xi_ij(m, :)] = selection_sell(g_j(m), i_chi_circuit(m, :), N);
        elseif m == 2
            g_j(m) = ~H_ij_modif(1, m-1) & H_ij_modif(1, m);
            tau_prev(1, m-1) = H_ij_modif(1, m);
            [o_chi_ij_modif(m, :), xi_ij(m, :)] = selection_sell(g_j(m), i_chi_circuit(m, :), N);
        else
            [g_j(m) , tau_prev(1, m-1)] = g_slice(H_ij_modif(1, m), H_ij_modif(1, m-1), tau_prev(1, m-2));
            [o_chi_ij_modif(m, :), xi_ij(m, :)] = selection_sell(g_j(m), i_chi_circuit(m, :), N);
        end
    end

y_out = any(xi_ij);

for n = N : -1 : 1
    k = N - (n-1);
    y_out_disp(:, n) = y_out(:, k);
    o_chi_ij_modif_disp(:, n) = o_chi_ij_modif(:, k);
end
end

% g-slice
function [g_i, tau_prev] = g_slice(h_modif_ij, h_modif_ij_prev, tau_double_prev)
    tau_prev = tau_double_prev | h_modif_ij_prev;
    invers_tau_prev = ~tau_prev;
    g_i = invers_tau_prev & h_modif_ij;
end

% selection-sell
function [o_chi_ij_modif, xi_ij] = selection_sell(g_i, i_chi_ij, N)
    if (g_i == 0)
     o_chi_ij_modif = i_chi_ij;
     g = zeros(1,N);
    else
     o_chi_ij_modif = zeros(1,N);
     g = ones(1,N);
    end

    xi_ij = i_chi_ij & g;
end
