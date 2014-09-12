% This function computes the migration distance between two vectors
% Here

function migdis = migration_distance(IX1, IX2)
    X_Width = 6;
    IX1_x = mod(IX1-1, X_Width); IX1_y = floor((IX1-1)/X_Width);
    IX2_x = mod(IX2-1, X_Width); IX2_y = floor((IX2-1)/X_Width);
    x_dis = abs(IX1_x - IX2_x);
    y_dis = abs(IX1_y - IX2_y);
    migdis = sum(x_dis + y_dis);
end