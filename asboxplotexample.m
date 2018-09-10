%% A.S. BOX PLOT EXAMPLE

% Tidy up
clear; clc; close all;

% Choose an example to run
example = 3; % OPTIONS: 1, 2 or 3


%% Run some examples

% Set up a full screen figure window
figfullscreen;

switch example % Set up switch case
    
    case 1
        
        % Call asboxplot with demo data
        asboxplot('demo')
        
    case 2
        
        % Load some sample data
        d = load('mileage.mat'); data = d.mileage;

        % Call asboxplot and change some properties
        asboxplot(data, 'fillcolor', [.9 .9 .9], 'boxwidth', .24, 'medianlength', 0.3, 'whiskerlength', 0.1)
        
    case 3
        
        % Load some sample data
        d = load('examgrades.mat'); data = d.grades;
        
        % Call asboxplot and change some properties
        asboxplot(data, 'fillcolor', 'w', 'mediancolor', [.2 .2 .2], 'outliercolor', 'r')
        
        % Throw an error if example number not recognised
    otherwise, error(['Example ' num2str(example) ' not recognised']);
end
        

%% Make the figures look a bit prettier

% Set names for the boxes
set(gca, 'xticklabel', {'Scenario A', 'Scenario B', 'Scenario C', 'Scenario D', 'Scenario E'});

% Set a title and a y axis label
title('Results of some amazing simulations');
ylabel(['Probability of something cool' 10]);

% Set font size for all text on the figure
settext({'title', 'labels', 'ticks'}, [50 40 26]);

