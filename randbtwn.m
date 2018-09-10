%% RAND BETWEEN
%
% One liner to generate array of random numbers between a and b.
%
% Written by A.J.Shattock - December 2016

function r = randbtwn(a, b, n)
    
    % Throw an error if trying to operate with more dimensions
    assert(numel(n) == 1, 'This simple function only works for a vector')
    
    % Generate random numbers for output
    r = a + (b - a) .* rand(n, 1);
end

