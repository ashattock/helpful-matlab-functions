%% REVERSE LEGEND
%
% Because Matlab legends are always back to front! Very basic function
% that calls the inbuilt function legend.m but just realigns the order
% of the legend labels and keys.
%
% This function requires at least two input arguments: The first arguemnt
% must be a plot handle, the second must be a cell array of strings 
% (sorry, got a bit lazy there!). Any additional arguments will feed into
% legend.m so should satisfy the requirements of that function.
%
% Useage example:
%       
%    % Create a figure and plot some random data
%    figure; h = area(cumsum(rand(4, 10))');
%    
%    % Reverse the legend order to match the plot -- put in best location
%    revlegend(h, {'A', 'B', 'C', 'D'}, 'location', 'best')
%
% Known issues:
%
%    - Pie charts have double the number of handles, should be able to cope
%        with this without using the fix h(1:2:end).
%
% Written by Roo - Feb 2015

function [leg, labelhandles, outh, outm] = revlegend(varargin)

% Need at least 2 arguments: a plot handle and a cell array of legend labels
assert(nargin >= 2, 'Not enough input arguments');

% This function needs the arguments in this order
if ismatrix(varargin{1}) && iscellstr(varargin{2})
    
    % Define the plot handle and legend labels appropriatly
    handle  = varargin{1}; % First argument must be a plot handle
    leglabs = varargin{2}; % Second argument must be legend labels
    
    % Check that they are the same size
    assert(numel(handle) == numel(leglabs), ...
        'Plot handle and legend labels should be of equal size');
    
else % Throw an error if not in cell array form
    
    % Problem with first input -- plot handle
    if ~ismatrix(varargin{1}), error('A plot handle must be defined'); end
    
    % Problem with second input -- legend labels
    if ~iscellstr(varargin{2}), error(['Legend labels must be defined ' ...
            'in a cell array of strings']); end
end

% Create a vector to reverse all elements -- the trick!
revord = fliplr(cumsum(ones(1, numel(leglabs))));

% Call the inbuilt function to do all the hard work -- input extra arguments if any given
[leg, labelhandles, outh, outm] = legend(handle(revord), leglabs(revord), varargin{3:end});

