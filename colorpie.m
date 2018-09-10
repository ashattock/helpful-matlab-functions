%% COLOR PIE
%
% Simply fills in the colours of a pie chart.
%
% Written by A.J.Shattock - July 2015

function colorpie(h, cols)
    
    % Number of pie segments (derived from handle length)
    %
    % NOTE: Pie charts have 2 handle elements per segment
    npie = numel(h) / 2;
    
    % Patch handle indices
    hinds = 1 : 2 : 2 * npie;
    
    % Iterate through the segments
    for j = 1 : npie
        
        % Change the colour of the patch to predefined colour
        set(h(hinds(j)), 'facecolor', cols(j, :));
    end
end
    
