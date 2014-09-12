% Here, we solve the linear sum assignment problem (LSAP) as following
% minimize 
%           sum (P_i - P_i_reference)^2
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
function [T t_max power_optimum] = lsap2_optimum(G_part, power, D, power_ref)

% Sort power and power_ref in ascending order
[power_sorted IX_power] = sort(power);
[power_ref_sorted IX_ref] = sort(power_ref);
power_optimum(IX_ref) = power_sorted;
power_optimum = power_optimum';
migdis = migration_distance(IX_ref, IX_power)
save('lsap2_power.txt', 'power_optimum', '-ascii');

T = G_part * power_optimum + D;
t_max = max(T);

end