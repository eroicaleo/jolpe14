% Here, we solve the linear programming as following
% minimize 
%           t_max = max_element(T);
% subject
%           T = G_part * P + D;
%           P >= 0;
%           sum(P) = P_constant
%
% We have proved that the optimum P will make every
% ti in the vector T same.
% Therefore, it can be solved analytically
%
function [T t_max P_optimum]= lp_optimum(G_part, power, D)
    G_part_inverse = inv(G_part);
    S = G_part \ D;
    S = power + S;
    t_max = sum(S) / sum(sum(G_part_inverse));
    T = repmat(t_max, size(power));
    P_optimum = G_part \ (T - D);
    
    save('lp_power.txt', 'P_optimum', '-ascii');
end