function [T_Total P_Dyn_Total T_Mean] = leakage(rconvection, mappingfile, Random_Permutation);

K = 1;
Ref_T_Low = 273.15+60;
Ref_Leak = 15*0.7/(Ref_T_Low^2*exp(K/Ref_T_Low));
Ref_Leak_Low = Ref_Leak*(Ref_T_Low^2*exp(K/Ref_T_Low));
Ref_T_High = 273.15+100;
Ref_Leak_High = Ref_Leak*(Ref_T_High^2*exp(K/Ref_T_High));
a = polyfit([Ref_T_Low Ref_T_High], [Ref_Leak_Low Ref_Leak_High], 1);
b = a(2);
a = a(1);
a = a;

% T = [273.15+60:2.5:273.15+100];
% Leak = Ref_Leak*(T.^2.*exp(K./T));
% Appro_Leak = a*T+b;
% plot(T, Leak, '-ro');
% hold on;
% plot(T, Appro_Leak, '-g^');

fid = fopen(mappingfile);
P_Dyn_Cell = textscan(fid, '%s %n');
fclose(fid);
P_Dyn = P_Dyn_Cell{1, 2};

% read the MATM
MATM_Permutation = load('matm_power.txt');
P_Dyn([1:36], 1) = MATM_Permutation;

% Adjust the g_amb
NUM_OF_CORES = 36;
rconvection_ref = 0.05;
r_ratio = 1;
R1=1.078125+11.25*r_ratio;
R2=0.212963+2.222222*r_ratio;
R3=0.025556+0.266667*r_ratio;
rh2a_base = [zeros(NUM_OF_CORES,1)+R1; zeros(4,1)+inf; zeros(4,1)+R2; zeros(4,1)+R3];
g_amb_ref = 1./(rh2a_base);
rconvection = rconvection;
r_ratio = rconvection/rconvection_ref;
R1=1.078125+11.25*r_ratio;
R2=0.212963+2.222222*r_ratio;
R3=0.025556+0.266667*r_ratio;
rh2a_base = [zeros(NUM_OF_CORES,1)+R1; zeros(4,1)+inf; zeros(4,1)+R2; zeros(4,1)+R3];
g_amb = 1./(rh2a_base);
g_amb_diff = g_amb - g_amb_ref;
g_amb_diff = [zeros(3*NUM_OF_CORES, 1); g_amb_diff];

g = dlmread('hotspot_input/matrix6by6.txt', '\t');
g = g(:, 1:end-1);
g = g + diag(g_amb_diff);
r = inv(g);

A = [zeros(36, 1)+a; zeros(120, 1)];
B = [zeros(36, 1)+b; zeros(120, 1)];
A = diag(A);
P_amb_diff = g_amb_diff.*298.15;
P_Dyn = P_Dyn+P_amb_diff;
P_Dyn_Total = [];
T_Total = [];
T_Mean = [];

for i = 1:size(Random_Permutation, 2)
    P_Dyn_Rand = P_Dyn;
    for j = 1:NUM_OF_CORES
        P_Dyn_Rand(j) = P_Dyn(Random_Permutation(j, i));
    end
    T_Rand = (g-A)\(P_Dyn_Rand+B);
    P_Rand_Dyn_Total = sum(P_Dyn_Rand(1:NUM_OF_CORES)+(a*T_Rand(1:NUM_OF_CORES)+b));
    T_Rand_Total = max(T_Rand(1:NUM_OF_CORES));
    T_Mean_Total = mean(T_Rand(1:NUM_OF_CORES));
    P_Dyn_Total = [P_Dyn_Total; P_Rand_Dyn_Total];
    T_Total = [T_Total; T_Rand_Total];
    T_Mean = [T_Mean; T_Mean_Total];
end

% If we provide some random permutation
% Record the best or the median random permutation in randopt_power.txt file
% and return
if (size(Random_Permutation, 2) ~= 0)
    [T_Rand_opt T_Rand_opt_index] = min(T_Total);
    Opt_Permutation = Random_Permutation(:, T_Rand_opt_index);
    P_Rand_opt = P_Dyn(1:NUM_OF_CORES, :);
    P_Rand_opt = P_Rand_opt(Opt_Permutation);
    save('randopt_power.txt', 'P_Rand_opt', '-ascii');
    return;
end

% Compute the temperature from MATM policy
T = (g-A)\(P_Dyn+B);
P_Dyn_Total = sum(P_Dyn(1:NUM_OF_CORES)+(a*T(1:NUM_OF_CORES)+b));
% T_Total = sum(T(1:NUM_OF_CORES));
T_Total = max(T(1:NUM_OF_CORES));
T_Mean = mean(T(1:NUM_OF_CORES));

Heuristic_Permutation = [];
Heuristic_Permutation = [Heuristic_Permutation load('lp_power.txt')];
Heuristic_Permutation = [Heuristic_Permutation load('lsap1_power.txt')];
Heuristic_Permutation = [Heuristic_Permutation load('lsap2_power.txt')];
Heuristic_Permutation = [Heuristic_Permutation load('randopt_power.txt')];

for i = 1:size(Heuristic_Permutation, 2)
    P_Dyn_Rand = P_Dyn;
    P_Dyn_Rand([1:36], 1) = Heuristic_Permutation(:, i);
    T_Rand = (g-A)\(P_Dyn_Rand+B);
    P_Rand_Dyn_Total = sum(P_Dyn_Rand(1:NUM_OF_CORES)+(a*T_Rand(1:NUM_OF_CORES)+b));
    T_Rand_Total = max(T_Rand(1:NUM_OF_CORES));
    T_Rand_Mean = mean(T_Rand(1:NUM_OF_CORES));
    P_Dyn_Total = [P_Dyn_Total; P_Rand_Dyn_Total];
    T_Total = [T_Total; T_Rand_Total];
    T_Mean = [T_Mean; T_Rand_Mean];
end

end
