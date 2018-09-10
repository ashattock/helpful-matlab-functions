%% AXIS SCALE
%
% Determines what scale the axis should be at, returning an appropriate
% scaler and string to append to a axis label
%
% Written by Roo - Dec 2013

function [axis_scaler, axis_label, upper_limit] = axisscale(plot_data)

% Perform sanity check
if min(size(plot_data)) > 1, error('Array is not 1 dimensional!'); end

% Get the upper limit of the data (trivial if singal point)
upper_limit = max(plot_data);

% Use for an upper axis limit of less than 1,000
if upper_limit < 1e3, axis_scaler = 1; axis_label = '';
    
    % Use for an upper axis limit of between 1,000 and 1,000,000
elseif upper_limit >= 1e3 && abs(upper_limit) < 1e6
    axis_scaler = 1e3; axis_label = ' (thousands)';
    
    % Use for an upper axis limit of over 1,000,000
elseif upper_limit >= 1e6 && abs(upper_limit) < 1e9
    axis_scaler = 1e6; axis_label = ' (millions)';
    
    % Use for an upper axis limit of over 1,000,000,000
elseif upper_limit >= 1e9
    axis_scaler = 1e9; axis_label = ' (billions)';
end
end