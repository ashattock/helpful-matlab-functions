%% A.S. 3D RESHAPE
%
% Turns a 2D matrix into a 3D matrix with dimensions specified by dims.
%
% Written by A.J.Shattock - July 2016

function out = as3shape(mat, dims)
    
    % Number of rows and columns of 2D input array
    [rows, cols] = size(mat);
    
    % Do the reshaping w.r.t rows
    shaped = reshape(mat', [cols rows/dims(3) dims(3)]);

    % Then just need to 3D transpose
    out = permute(shaped, [2 1 3]);
end

