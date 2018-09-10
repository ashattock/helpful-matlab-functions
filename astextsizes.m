%% A.S. TEXT SIZES
%
% Takes a multilined string array and sets different user-defined test sizes to
% the different lines.
%
% Written by A.J.Shattock - March 2015

function outstr = astextsizes(thetext, fsizes)
    
    % Format the strings into cells
    strcell = strread(thetext, '%s', 'whitespace', '\n'); %#ok<FPARK>
    
    % Number of seperate lines
    ntlines = size(strcell, 1);
    
    % Make sure an appropriate number of font sizes has been specified
    assert(ismember(numel(fsizes), [1 ntlines]), 'Inappropriate number of font sizes specified')
    
    % Initiate output string
    outstr = [];
    
    % Iterate through the lines of text
    for j = 1 : ntlines
        
        % Select the appropriate font size for this line of text
        if numel(fsizes) == 1, lsize = fsizes; else lsize = fsizes(j); end
        
        % Set the appropriate font size for this current line on text
        outstr = [outstr 10 ['\fontsize{' num2str(lsize) '}' strcell{j}]]; %#ok<AGROW>
    end
    
    % Get rid of first character (new line)
    outstr = outstr(2 : end);
end
    
