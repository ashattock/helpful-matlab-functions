%% FIG FULL SCREEN
%
% Simple function to make figure full screen. Optional inputs 'horizontaltrim'
% and 'verticaltrim' do exactly that... trim the size of the figure.
%
% Examples of useage:
%
%  figfullscreen;
%  figfullscreen(2158);
%  figfullscreen(2158, 'horizontaltrim', 100, 'verticaltrim', 50);
%  figfullscreen('horizontaltrim', 200);
%
% Written by A.J.Shattock - March 2014

function fighandle = figfullscreen(varargin)

% Check whether a figure number is given
if nargin == 0 || ~isnumeric(varargin{1})
    
    % Turn on visibility of all open figures
    hvis = get(0, 'handlevisibility'); set(0, 'handlevisibility', 'on');
    
    % Get the figure numbers of all figures and reset visibility
    nfigs = get(0, 'children'); set(0, 'handlevisibility', hvis);
    
    % -- Determine new figure number (R2012b and R2015b need different code) -- %
    
    try % The follwoing peice of code works for R2012b
        
        % We'll use the next available figure number
        fignum = max(nfigs) + 1;
        
        % If no figures are open, use 1
        if isempty(fignum), fignum = 1; end
        
    catch % The follwoing peice of code works for R2015b
        
        % If no figures are open, use fignum = 1
        if isempty(nfigs), fignum = 1; else
            
            % We'll use the next available figure number
            fignum = max(cat(1, nfigs.Number)) + 1;
        end
    end
    
    % What additional arguments are given, if any
    if nargin == 0, exargs = []; else exargs = varargin; end
    
    % If a figure number is given, use it. Also get additional arguments
else fignum = varargin{1}; exargs = varargin(2:end);
end

% Make sure that if there are any additional arguments they are paired
assert(~logical(mod(numel(exargs), 2)), 'Requires property name-value pairs');

% The size of the moniter
ssize = get(0, 'screensize');

% Define default extra options
exoptions = struct('horizontaltrim', 0, 'verticaltrim', 0, 'figname', 0);

% Available extra options
optionnames = fieldnames(exoptions);

% for trimpair = reshape(varargin, 2, []) -- # pair is {propName; propValue}
for j = 1 : numel(exargs) / 2
    
    % Name and value of current extra option
    trimname  = lower(exargs{j * 2 - 1});
    trimvalue = exargs{j * 2};
    
    % Check if this is a valid option
    if any(strcmp(trimname, optionnames))
        
        % Overwrite default option
        exoptions.(trimname) = trimvalue;
    
        % ... throw an error if it's not a valid input
    else error([trimname ' is not a valid input argument']);
    end
end

% Rename trim options for easy referencing
htrim = exoptions.horizontaltrim;
vtrim = exoptions.verticaltrim;

% Trim the figure size as necessary
trimmedscreen = [(htrim / 2) (vtrim / 2) (ssize(3) - htrim) (ssize(4) - vtrim)];

% Actually create the figure and set the size
fighandle = figure(fignum); set(fignum, 'position', trimmedscreen);

% Also rename fig name option
fname = exoptions.figname;

% Name the figure if figname input has been defined and is non trivial
if fname ~= 0, set(fighandle, 'name', num2str(fname), 'numbertitle', 'off'); end

end

