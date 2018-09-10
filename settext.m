%% SET TEXT
%
% Small function to change all the different text on a figure.
%
% Possible 'type' inputs:
%  'ticks'  - x and y axis tick labels
%  'labels' - x and y axis labels
%  'title'  - figure title
%
% Text properties (in specified order):
%  1) font       - mandatory argument
%  2) fontsize   - optional argument (default: 10pt)
%  3) fontweight - optional argument (default: 'bold')
%
% Useage:
%
%   % Set text size, font and weight
%   settext({'title', 'labels', 'ticks'}, [40 32 22]);
%
% Written by A.J.Shattock - July 2014

function settext(texttype, varargin)
    
    % Ensure that at least one text property is defined
    assert(~isempty(varargin), 'Not enough input arguments');
    
    % Number of texttype inputs
    if iscell(texttype), ntype = numel(texttype); else ntype = 1; end
    
    % Either use user input or predefined default values for font type and weight
    if numel(varargin) > 1, fonttype   = varargin{2}; else fonttype   = 'calibri'; end
    if numel(varargin) > 2, fontweight = varargin{3}; else fontweight = 'bold';    end
    
    % Font size is first argument
    fontsize = varargin{1}; nsize = numel(fontsize);
    
    % % Either use user input or predefined default values for font size and weight
    % if numel(varargin) > 1, fontsize = varargin{2}; else fontsize = 10; end
    % if numel(varargin) > 2, fontweight = varargin{3}; else fontweight = 'bold'; end
    %
    % % Font type is first argument
    % font = varargin{1}; nsize = numel(fontsize);
    
    % Number of fontsize inputs must be 1 (all text has same size) or ntype (each texttype has own size)
    assert(ismember(nsize, [1 ntype]), 'Inconsistent number of fontsize inputs');
    
    % Has 'text' been specified as an input
    if ntype == 1, texist = strcmp(texttype, 'text');
    else texist = ~cellfun(@isempty, strfind(texttype, 'text')); end
    
    % To alter text, we need to alter everything - thus we do it first
    if any(texist)
        
        % Font size for this texttype (use individual size or only size given)
        if nsize == 1, tsize = fontsize; else tsize = fontsize(find(texist, 1, 'first')); end
        
        % Properties to alter and their values
        props  = {'fontname', 'fontsize', 'fontweight'};
        values = {fonttype, tsize, fontweight};
        
        % Alter all instances of each of these properties in the current axes
        for i = 1:numel(props), set(findall(gca, '-property', props{i}), props{i}, values{i}); end
    end
    
    % Iterate through the texttypes
    for i = 1:ntype
        
        % Current type of text to format (within a cell if multiple texttypes given)
        if ntype > 1, thistype = texttype{i}; else thistype = texttype; end
        
        % Font size for this texttype (use individual size or only size given)
        if i > nsize, thissize = fontsize; else thissize = fontsize(i); end
        
        % Set up switch case for texttype
        switch thistype
            
            % Set text properties accordingly
            case 'ticks', set(gca, 'fontname', fonttype, 'fontsize', thissize, 'fontweight', fontweight);
                
            case 'labels' % Repeated for x and y axes labels
                
                % Which axes to apply to
                ax = {'x', 'y'};
                
                % Iterate through the axes
                for j = 1:numel(ax)
                    
                    % This axis label
                    axl = [ax{j} 'label'];
                    
                    % Set text properties accordingly
                    set(get(gca, axl), 'fontname', fonttype, 'fontsize', thissize, 'fontweight', fontweight);
                end
                
                % Set text properties accordingly
            case 'title', set(get(gca, 'title'), 'fontname', fonttype, 'fontsize', thissize, 'fontweight', fontweight);
                
            case 'text' % Do nothing, already covered this
                
                % Throw an error if texttype is not recognised
            otherwise, error(['Text type ' num2str(thistype) ' not recognised'])
        end
    end
end

