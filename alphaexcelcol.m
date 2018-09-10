%% ALPHA EXCEL COL
%
% You know the colulmn number of the excel file you want to read or write,
% but not the alphabetic column handle? Well, you've come to the right place.

function excelcol = alphaexcelcol(nexcelcol)

% Ensure input is a positive integer
assert(nexcelcol > 0 && ~mod(nexcelcol, 1), ...
    'Column index must be a positive integer');

% Standard options for alhpabetic characters
in.charstart = 64;        in.nalphabet = 26;

% Determine the number of LHS alphas we need
lhs1 = nonzerofloor(nexcelcol, in.nalphabet);
lhs2 = nonzerofloor(lhs1,      in.nalphabet);
lhs3 = nonzerofloor(lhs2,      in.nalphabet);

% What are these letters (trivial or not)
if lhs1 > 0, alphalhs1 = alphaind(in, lhs1); else alphalhs1 = ''; end
if lhs2 > 0, alphalhs2 = alphaind(in, lhs2); else alphalhs2 = ''; end
if lhs3 > 0, alphalhs3 = alphaind(in, lhs3); else alphalhs3 = ''; end

% Concatonate LHS
lhs = [alphalhs3 alphalhs2 alphalhs1];

% Determine RHS alpha (the only non-trivial if nexcelcol < in.nalphabet)
rhs = alphaind(in, nexcelcol);

% Finally, concatonate the LHS and RHS
excelcol = [lhs rhs];


%% Nested functions

% This is where the magic happens
    function alpha = alphaind(in, ind)
        
        % Convert the index into a letter
        alpha = char(mod(in.charstart + ind, in.charstart + in.nalphabet * ...
            nonzerofloor(ind, in.nalphabet)) + in.charstart);
    end

% Needed this function to deal with Z
    function output = nonzerofloor(numerator, denominator)
        
        % We need to take action if teh modulus is 0
        if mod(numerator, denominator) == 0, take = 1; else take = 0; end

        % Than do the standard floor function
        output = floor(numerator / denominator) - take;
    end
end

