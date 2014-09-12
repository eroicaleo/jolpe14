% This function generates new partial thermal resistance matrix
% which is affected by leakage temperature dependency
% In this function G is the partial thermal resistance matrix
% D is the constant
% B is the original thermal conductance matrix
function [G D] = ldt_matrix(B, rconvection)
    % Compute the linear model for leakage power
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
    
    % Compute and Adjust the g_amb
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
    
    % Now this is the new thermal conductance matrix under different
    % convection resistance
    g = B + diag(g_amb_diff);
    
    % Add leakage contant to the thermal conductance matrix
    A = [zeros(36, 1)+a; zeros(120, 1)];
    B = [zeros(36, 1)+b; zeros(120, 1)];
    A = diag(A);
    
    % Now this is the new thermal conductance considering leakage power
    g_leakage = g - A;
    
    % Now need to compute constant D
    % g_leakage * T = P_Dyn + B
    % It can be computed as the T value when P_Dyn = [0 .. 0 P_amb]
    fid = fopen('hotspot_input/DBAmapping.txt');
    P_Dyn_Cell = textscan(fid, '%s %n');
    fclose(fid);
    P_Dyn = P_Dyn_Cell{1, 2};
    % Reset the power of 1:NUM_OF_CORES to 0
    P_Dyn(1:NUM_OF_CORES) = 0;
    % Compute the T
    T = g_leakage \ (P_Dyn + B);
    % Extract D
    D = T(1:NUM_OF_CORES);
    
    % Now the final one is to get the partial thermal resistance matrix P
    G = inv(g_leakage);
    G = G(1:NUM_OF_CORES, 1:NUM_OF_CORES);
    
    % Debug code, needs to be removed for release use
    P_Dyn = P_Dyn_Cell{1, 2};
    T_1 = g_leakage \ (P_Dyn + B);
    T_2 = G * P_Dyn(1:NUM_OF_CORES) + D;
    T_diff = abs(T_2 - T_1(1:NUM_OF_CORES));
    
end
