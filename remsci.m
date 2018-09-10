%% REM SCI
%
% Remove scientific notation form axes. Should be called after other
% formatting tasks have been completed (i.e. setting font sizes, axes
% limits etc).
%
% Useage:
%
%   h = remsci(h, 'y', 'x');
%
% Written by Roo - March 2015

function handle = remsci(varargin)

% Sanity check on number of inputs
assert(nargin >= 2, 'Not enough input arguments');

% Figure handle is first argument
handle = varargin{1};

% Which axes are to be de-scientific-notationed
axes = varargin(2:end);

% Iterate through these specifed axes
for i = 1:numel(axes)
    
    % Current axis
    axis = num2str(axes{i});

    % Current tick labels on this axis
    axticks = get(gca, [axis 'tick'])';
    
    % Store full intergers with thousand separator in cells
    for j = 1:numel(axticks), axlabels{1, j} = thousep(axticks(j)); end %#ok<AGROW>
    
    % Set this values as the new tick labels
    set(handle, [axis 'ticklabel'], axlabels)
end

