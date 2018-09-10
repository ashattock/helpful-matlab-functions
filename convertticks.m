%% CONVERT TICKS
%
% Converts x or y tick marks to strings, and allows pre- or post-
% characters.
%
% Written by A.J.Shattock - May 2015

function convertticks(ax, pretick, postinput)
    
    % Axis we're converting
    ax = lower(ax); drawnow;
    
    % Make sure it's either x or y
    assert(ismember(ax, {'x', 'y'}), 'Axis not recognised');
    
    % User can also use 'auto' functionality
    if strcmp(postinput, 'auto')
        
        % Using auto, we'll find the current upper limit of the axis and use that
        if strcmp(ax, 'x'), tlims = xlim; elseif strcmp(ax, 'y'), tlims = ylim; end
        
        % Select the upper limit (the second, or last, value)
        postinput = tlims(end);
    end
    
    % If posttick is not already a string we need to form one
    if ischar(postinput), posttick = postinput;
        
        % Set up switch case for value of posttick
        switch postinput
            
            % Form a string describing:
            case 'k', pval = 1e3; % Thousands
            case 'm', pval = 1e6; % Millions
            case 'b', pval = 1e9; % Billions
            case '%', pval = 1;   % Percentage case
            case '',  pval = 1;   % Nothing to do
                
                % Throw an error if case is not recognised
            otherwise, error('Value of ''posttick'' not recognised');
        end
    else
        
        % Standard values of ticks
        sval = [1e3 1e6 1e9];
        
        % If input is a standard value, we're good to continue
        if ismember(postinput, sval), pval = postinput; else
            
            % If not, find the standard value to display
            pval = sval(find(postinput > sval, 1, 'last' ));
        end
        
        % Set up switch case for posttick character
        switch pval
            
            % Form a string describing:
            case 1e3, posttick = 'k'; % Thousands
            case 1e6, posttick = 'm'; % Millions
            case 1e9, posttick = 'b'; % Billions
                
                % Throw an error if case is not recognised
            otherwise, error('Value of ''posttick'' not recognised');
        end
    end
    
    % Name the current axes, and set labelling mode to auto temporarily
    tax = gca; tax.([upper(ax) 'TickLabelMode']) = 'auto';
    
    % The current tick labels
    ticklabels = get(tax, [ax 'ticklabel']);
    
    % The values of the tick labels
    tickvals = get(tax, [ax 'tick']);
    
    % Determine scale factor
    scaleftr = (tickvals(end) / str2double(ticklabels(end, :))) / pval;
    
    % Number of them
    nticks = size(ticklabels, 1);
    
    % Preallocate cells for new array of strings
    newticks = cell(1, nticks);
    
    % Iterate through the tick labels
    for ii = 1:nticks
        
        % Cut out the spaces, we might want something at the end
        %             thistick = strrep(ticklabels{ii, :}, ' ', ''); % R2015
        thistick = strrep(ticklabels(ii, :), ' ', ''); % R2012
        
        % Apply scale factor
        thistick = num2str(str2double(thistick) * scaleftr);
        
        % Add the pre- and post-tick text
        newticks{ii} = [pretick thistick posttick];
    end
    
    % Set these new ticks on the current axis
    set(tax, [ax 'ticklabel'], newticks);
end

