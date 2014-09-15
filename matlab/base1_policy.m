%%----------------------------------------------------------------------------------------------------
% Here, we implement a baseline policy as following
% We first use the default task mapping
% then we start from the core with the highest temperature
% and swap its task with a core with the lowest temperature and power less than it
% Input: 
%   G_part, D : matrix G and vector D in equation (2) 
%   power     : Initial task mapping
% Output:
%   T             : Temperature of each core
%   power_optimum : Power of each core
%   t_max         : The maximum temperature
%%----------------------------------------------------------------------------------------------------

function [T t_max power_optimum] = base1_policy(G_part, power, D)

  T_before = G_part * power + D;
  [T_before_sorted, IX] = sort(T_before)

end
