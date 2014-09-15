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

function [T t_max power_base1] = base1_policy(G_part, power, D)

  T_before = G_part * power + D;
  %%----------------------------------------------------------------------------------------------------
  % Sort the temperature from high to low
  % And then sort the power vector based on temperature
  %%----------------------------------------------------------------------------------------------------
  [T_sorted, IX] = sort(T_before, 'descend');
  power_sorted = power(IX);
  base1_IX = (1 : size(T_sorted, 1))';

  %%----------------------------------------------------------------------------------------------------
  %% www.mathworks.com/help/matlab/matlab_prog/find-array-elements-that-meet-a-condition.html
  %% The baseline algorithm moves the task on a hotter core to a cooler core with lower power task
  %% It starts from the hottest core, i.e. T_sorted[1]
  %%----------------------------------------------------------------------------------------------------
  for i = 1 : size(T_sorted, 1)
    %%----------------------------------------------------------------------------------------------------
    %% Find all cores with less power
    %%----------------------------------------------------------------------------------------------------
    I = find(power_sorted < power_sorted(i));

    %%----------------------------------------------------------------------------------------------------
    %% No cooler core with less power, don't swap
    %%----------------------------------------------------------------------------------------------------
    if ~size(I, 1) || I(end) < i
      continue
    end

    %%----------------------------------------------------------------------------------------------------
    %% Find the coolest core with less power
    %%----------------------------------------------------------------------------------------------------
    last_ix_sorted = I(end);
    last_ix = IX(last_ix_sorted);

    %%----------------------------------------------------------------------------------------------------
    %% Swap the two tasks
    %% Note that IX(i) and last_ix are non-sorted index, they are for base1_IX, which is a non-sorted vector
    %% i and last_ix_sorted are sorted index, they are for power_sorted which is a sorted vector
    %%----------------------------------------------------------------------------------------------------
    base1_IX([IX(i), last_ix]) = base1_IX([last_ix, IX(i)]);
    power_sorted([i, last_ix_sorted]) = power_sorted([last_ix_sorted, i]);
  end

  %%----------------------------------------------------------------------------------------------------
  %% Sanity check
  %% Needs to make sure it is permutation
  %%----------------------------------------------------------------------------------------------------
  base1_IX_sorted = sort(base1_IX);
  if ~isequal(base1_IX_sorted, (1 : size(T_sorted, 1))')
    print('Something wrong in the base1_policy')
    exit
  end

  %%----------------------------------------------------------------------------------------------------
  %% Return values
  %%----------------------------------------------------------------------------------------------------
  power_base1 = power(base1_IX);
  save('base1_power.txt', 'power_base1', '-ascii');

  T = G_part * power_base1 + D;
  t_max = max(T);

end
