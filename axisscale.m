%% AXIS SCALE
%
% Determines what scale the axis should be at, returning an appropriate
% scaler and string to append to a axis label.
%
% Written by A.J.Shattock - December 2013

function [axscaler, axlabel, upperlimit] = axisscale(plotdata)
    
    % Perform sanity check
    if min(size(plotdata)) > 1, error('Array is not 1 dimensional!'); end
    
    % Get the upper limit of the data (trivial if singal point)
    upperlimit = max(plotdata);
    
    % Use for an upper axis limit of less than 1,000
    if upperlimit < 1e3, axscaler = 1; axlabel = '';
        
        % Use for an upper axis limit of between 1,000 and 1,000,000
    elseif upperlimit >= 1e3 && abs(upperlimit) < 1e6
        axscaler = 1e3; axlabel = ' (thousands)';
        
        % Use for an upper axis limit of over 1,000,000
    elseif upperlimit >= 1e6 && abs(upperlimit) < 1e9
        axscaler = 1e6; axlabel = ' (millions)';
        
        % Use for an upper axis limit of over 1,000,000,000
    elseif upperlimit >= 1e9
        axscaler = 1e9; axlabel = ' (billions)';
    end
end

