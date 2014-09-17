
%%----------------------------------------------------------------------------------------------------
%% Specify the task pattern here
%% 1. uniform 2. cool tri. 3. hot tri. 4. normal 5. inverse normal
%%----------------------------------------------------------------------------------------------------

num_of_scenarios = 5;
scenario_names = { ...
'uniform',      ...
'cooltriangle', ...
'hottriangle',  ...
'norm',         ...
'invnorm'       ...
};

%%----------------------------------------------------------------------------------------------------
%% Specify the number of the policies here
%% 1. matm 2. lower bound 3. lsap1 4. lsap2 5. random 6. base1
%%----------------------------------------------------------------------------------------------------
num_of_policies = 6;
policy_names = { ...
'matm',  ...
'lb',    ...
'lsap1', ...
'lsap2', ...
'rand',  ...
'base1', ...
};

%%----------------------------------------------------------------------------------------------------
%% For the 80oC case, do all 5 scenarios. For the 85oC and 90oC, only do the uniform case.
%%----------------------------------------------------------------------------------------------------
if ~exist('results_cell', 'var')
  results_cell = cell(num_of_scenarios, 1);

  for i = 1 : num_of_scenarios
    [Power_Breakdown r_final P_total p_chip t_mean] = loadmatrix(273.15+80, i);
    results_cell{i} = {Power_Breakdown r_final P_total p_chip t_mean};
  end
end

if ~exist('results_cell_85', 'var')
  results_cell_85 = cell(num_of_scenarios, 1);

  for i = 1 : 1
    [Power_Breakdown r_final P_total p_chip t_mean] = loadmatrix(273.15+85, i);
    results_cell_85{i} = {Power_Breakdown r_final P_total p_chip t_mean};
  end
end

if ~exist('results_cell_90', 'var')
  results_cell_90 = cell(num_of_scenarios, 1);

  for i = 1 : 1
    [Power_Breakdown r_final P_total p_chip t_mean] = loadmatrix(273.15+90, i);
    results_cell_90{i} = {Power_Breakdown r_final P_total p_chip t_mean};
  end
end

%%----------------------------------------------------------------------------------------------------
%% Figure 10 Convective resistance comparison between 5 different task allocation policies
%%----------------------------------------------------------------------------------------------------
fileID = fopen('figure10.txt','w');
fprintf(fileID, '%-20s', 'policy');
for i = 1 : num_of_policies
  fprintf(fileID, '%-20s', policy_names{1, i});
end
fprintf(fileID, '\n');
for i = 1 : num_of_scenarios
  fprintf(fileID, '%-20s', scenario_names{1, i});
  fprintf(fileID, '%-20.4f', results_cell{i, 1}{1, 2}');
  fprintf(fileID, '\n');
end
fclose(fileID);

%%----------------------------------------------------------------------------------------------------
%% Figure 12 Power breakdown
%%----------------------------------------------------------------------------------------------------
fileID = fopen('figure12.txt','w');
fprintf(fileID, '80oC\n');
fprintf(fileID, '%-20s%-20s%-20s%-20s', 'powertype', 'dynamic', 'leakage', 'fan');
fprintf(fileID, '\n');
for i = 1 : num_of_policies
  fprintf(fileID, '%-20s', policy_names{1, i});
  fprintf(fileID, '%-20.4f', results_cell{1, 1}{1, 1}(i, :));
  fprintf(fileID, '\n');
end

fprintf(fileID, '\n85oC\n');
fprintf(fileID, '%-20s%-20s%-20s%-20s', 'powertype', 'dynamic', 'leakage', 'fan');
fprintf(fileID, '\n');
for i = 1 : num_of_policies
  fprintf(fileID, '%-20s', policy_names{1, i});
  fprintf(fileID, '%-20.4f', results_cell_85{1, 1}{1, 1}(i, :));
  fprintf(fileID, '\n');
end

fprintf(fileID, '\n90oC\n');
fprintf(fileID, '%-20s%-20s%-20s%-20s', 'powertype', 'dynamic', 'leakage', 'fan');
fprintf(fileID, '\n');
for i = 1 : num_of_policies
  fprintf(fileID, '%-20s', policy_names{1, i});
  fprintf(fileID, '%-20.4f', results_cell_90{1, 1}{1, 1}(i, :));
  fprintf(fileID, '\n');
end
fclose(fileID);

%%----------------------------------------------------------------------------------------------------
%% Table 2 Fan power savings of MATM compared to the rand and base1
%%----------------------------------------------------------------------------------------------------
matm_ix = 1;
rand_ix = 5;
base_ix = 6;

impr_vs_rand = zeros(num_of_scenarios, 1);
impr_vs_base = zeros(num_of_scenarios, 1);

for i = 1 : num_of_scenarios
  fan_power_rand = results_cell{i, 1}{1, 1}(rand_ix, 3);
  fan_power_base = results_cell{i, 1}{1, 1}(base_ix, 3);
  fan_power_matm = results_cell{i, 1}{1, 1}(matm_ix, 3);
  impr_vs_rand(i, 1) = (fan_power_rand - fan_power_matm) / fan_power_rand;
  impr_vs_base(i, 1) = (fan_power_base - fan_power_matm) / fan_power_base;
end

fileID = fopen('table2.txt','w');
fprintf(fileID, '%-20s', 'Workload');
for i = 1 : num_of_scenarios
  fprintf(fileID, '%-20s', scenario_names{1, i});
end
fprintf(fileID, '\n');
fprintf(fileID, '%-20s', 'Impr. vs rand');
fprintf(fileID, '%-20.4f', '', impr_vs_rand);
fprintf(fileID, '\n');
fprintf(fileID, '%-20s', 'Impr. vs base1');
fprintf(fileID, '%-20.4f', impr_vs_base);
fclose(fileID);
