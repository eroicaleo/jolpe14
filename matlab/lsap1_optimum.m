% Here, we solve the linear sum assignment problem (LSAP) as following
% minimize 
%           sum(T)
% subject
%           P is a permutation
%
% We have proved that the following property:
% if G = [G1 G2 ... Gn] which Gi is column vector
% and the column sum is [s1 s2 ... sn]
% with s1 <= s2 <= ... <= sn
% then the optimum allocation
% optimum P will be the allocation
% P = [p1 p2 ... pn] with p1 <= p2 <= ... <= pn
function [T t_max power_optimum] = lsap1_optimum(G_part, power, D)

% Compute the column sum of G_part
G_column_sum = sum(G_part);
% Sort the row vector
[G_column_sum_sorted IX] = sort(G_column_sum);
% Sort power and flip it
[power_sorted IX_power] = sort(power, 'descend');
% Sort G_part base on the column sum
G_sorted = G_part(:, IX);

% Compute the migration distance
migdis = migration_distance(IX', IX_power)
% Find out the optimum power
power_optimum(IX) = power_sorted;
power_optimum = power_optimum';

save('lsap1_power.txt', 'power_optimum', '-ascii');

% Output the results
T = G_sorted * power_sorted + D;
t_max = max(T);

end