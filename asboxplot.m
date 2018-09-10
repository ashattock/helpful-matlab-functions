%% A.S. BOX PLOT
%
% Does Matlab's inbulit boxplot function make you want to chunder? Excellent.
% This delightful function should help to make your world a brighter place.
%
%  asboxplot(X) produces n good-looking box plots of the data in X, where n is the
%     number of columns of X. If X is a vector there is just one box. On each box, 
%     the central mark is the median, the edges of the box are the 25th and 75th
%     percentiles, the whiskers extend to the most extreme datapoints the algorithm
%     considers to be not outliers, and the outliers are plotted individually.  
%
%  asboxplot(..., 'PARAM1', val1, 'PARAM2', val2, ...) specifies optional
%     parameter name/value pairs:
%
%           'mediancolor' {*} -- colour of median bar (1 or n entries)
%          'whiskercolor' {*} -- colour of whisker bars (1 or n entries)
%             'fillcolor' {*} -- colour of filled box (1 or n entries)
%             'linecolor' {*} -- colour of box outline (1 or n entries)
%             'datacolor' {*} -- colour of data points (1 or n entries)
%          'outliercolor' {*} -- colour of outlier points (1 or n entries)
%           'medianwidth' {8} -- linewidth of median line
%           'linewidth' {2.5} -- linewidth of box outline lines
%          'whiskerwidth' {6} -- linewidth of whisker lines
%           'boxwidth' {0.18} -- width of filled box
%       'medianlength' {0.22} -- length of median line
%      'whiskerlength' {0.08} -- length of whisker lines
%       'datamarkersize' {10} -- size of data markers
%     'outliermarkersize' {5} -- size of outlier markers
%     'datamarkershape' {'o'} -- shape of data markers
%        'outliershape' {'s'} -- shape of outlier markers
%           'outliers' {'on'} -- flag for visibility of outliers
%
%   * = see nested defaultcols function for default colours
%
% For a demonstration of this function, use: asboxplot('demo')
%
% Written by Roo - Jan 2015
 
function asboxplot(varargin)

% Throw an error if not enough input arguments
if nargin < 1, error('Not enough input arguments'); else
    
    % Create a full figure and random data if running demo
    if strcmpi(varargin{1}, 'demo'), data = rand(8, 5); %#ok<ALIGN>
    
        % Otherwise the first input must be the data array
    else data = varargin{1}; end
    
    % Redefine any additional arguments if given
    if numel(varargin) > 1, exargs = varargin(2:end); else exargs =[]; end
end

% Ensure that data is in matrix form
assert(ismatrix(data), 'First input must be an array')

% Make sure that if there are any additional arguments they are paired
assert(~logical(mod(numel(exargs), 2)), 'Requires property name-value pairs');

% Number of data points and number of boxes to plot
ndata = size(data, 1); nbox  = size(data, 2);


%% Set up figure window - need a temp one to plot crap Matlab version

% Turn on visibility of all open figures
hvis = get(0, 'handlevisibility'); set(0, 'handlevisibility', 'on');

% Get the figure numbers of all figures and reset visibility
nfigs = get(0, 'children'); set(0, 'handlevisibility', hvis)

% Either get current figure or get ready to set up figure 1
if isempty(nfigs), currfig = 1; tmpfig = 1; else currfig = gcf; tmpfig = max(nfigs) + 1; end

% Plot the crappy standard matlab box plots
%
% NOTE: We need to do this to pick up the objects -- I think! Would be happy to be corrected!
figure(tmpfig); boxplot(data);


%% Store values needed to recreate the boxplots

% Define the box objects that we need to recreate boxes
boxobjects = {'Upper Whisker', 'Lower Whisker', 'Median'};

% Preallocate arrays to store y values needed to recreate the boxes
upperwhisker = zeros(1, nbox);      upperqrtile  = zeros(1, nbox);
lowerwhisker = zeros(1, nbox);      lowerqrtile  = zeros(1, nbox);

% Also preallocate for the median
median = zeros(1, nbox); 

% Iterate through the boxplot objects
for j = 1:numel(boxobjects), thisob = boxobjects{j};
    
    % The current object
    thisobject = findobj(gcf, 'tag', thisob);
    
    % Ydata of current object
    yvalbox = get(thisobject, 'ydata'); ri = 0;
    
    % Bit of a fudge to get single box working
    if nbox == 1, yvalbox = {yvalbox}; end
    
    % Iterate through the scenarios - stored backwards in objects for some reason
    for k = fliplr(1:nbox), ri = ri + 1; % Use ri to store in appropriate order
        
        switch thisob % Set up switch case for object
            
            case 'Upper Whisker' % Upper whisker case
                
                % Store upper whisker and upper quartile data
                upperwhisker(1, ri) = max(yvalbox{k});
                upperqrtile(1, ri)  = min(yvalbox{k});
                
            case 'Lower Whisker' % Lower whisker case
                
                % Store lower whisker and lower quartile data
                lowerwhisker(1, ri) = min(yvalbox{k});
                lowerqrtile(1, ri)  = max(yvalbox{k});
                
                % Store median data
            case 'Median', median(1, ri) = unique(yvalbox{k});
        end
    end
end


%% Set up colour scheme

% if colour inputs not defined...

% Default outline and fill colours
medcol = defaultcols(nbox, 'main');
wskcol = defaultcols(nbox, 'main');
filcol = defaultcols(nbox, 'fill');

% Default line, data and outlier colours
lincol = defaultcols(nbox, 'line');
datcol = defaultcols(nbox, 'data');
outcol = defaultcols(nbox, 'out');


%% Set default properties

% if box properties are not defined...

% Thinkness of box lines: standard, median and whiskers
sthick = 2.5;        mthick = 8;         wthick = 6;

% Box, whisker and median width, respectively
bwidth = 0.18;       wwidth = 0.08;      mwidth = bwidth + 0.04;

% Data and outlier marker shape
dshape = 'o';        oshape = 's';

% Data and outlier marker size
dsize = 10;          osize = 5;   


%% Apply user defined options

% Set default options within a structure
opt = struct(...
    ... Option              Default
    'mediancolor',          medcol, ...
    'whiskercolor',         wskcol, ...
    'fillcolor',            filcol, ...
    'linecolor',            lincol, ...
    'datacolor',            datcol, ...
    'outliercolor',         outcol, ...
    'medianwidth',          mthick, ...
    'linewidth',            sthick, ...
    'whiskerwidth',         wthick, ...
    'boxwidth',             bwidth, ...
    'medianlength',         mwidth, ...
    'whiskerlength',        wwidth, ...
    'datamarkershape',      dshape, ...
    'outliershape',         oshape, ...
    'datamarkersize',       dsize, ...
    'outliermarkersize',    osize, ...
    'outliers',             'on');

% Available trim options
optionnames = fieldnames(opt);

% for trimpair = reshape(varargin, 2, []) -- # pair is {propName; propValue}
for j = 1 : numel(exargs) / 2
    
    % Name and value of current trim option
    optionname  = lower(exargs{j * 2 - 1});
    optionvalue = exargs{j * 2};
    
    % Check if this is a valid option
    if any(strcmp(optionname, optionnames))
        
        % Overwrite default option
        opt.(optionname) = optionvalue;
    
        % ... throw an error if it's not a valid input
    else error([optionname ' is not a valid input argument']);
    end
end

% Redefine any non-colour options specified by the user

% Thinkness of box lines: standard, median and whiskers
sthick = opt.linewidth;
mthick = opt.medianwidth;
wthick = opt.whiskerwidth;

% Box, whisker and median width, respectively
bwidth = opt.boxwidth;
wwidth = opt.whiskerlength;
mwidth = opt.medianlength;

% Data and outlier marker size
dsize = opt.datamarkersize;
osize = opt.outliermarkersize;

% Turn outlier size to tiny to essentailly turn them off
if strcmpi(opt.outliers, 'off'), osize = 1e-9; end


%% Seperate outliers from other data points

% Outliers that are either too high or too low
outhigh = data > repmat(upperwhisker, ndata, 1);
outlow  = data < repmat(lowerwhisker, ndata, 1);

% All outliers together
allout = logical(outhigh + outlow);


%% Let's get plotting

% Close the temporary figure and open the one we want to plot on
close(tmpfig); figure(currfig); hold on; use = struct;

% Iterate through the boxes to plot
for j = 1:nbox
    
    % Specify the fields of opt that specify colours - this bit is a right work up!
    coltypes = {'mediancolor', 'whiskercolor', 'fillcolor', 'linecolor', 'datacolor', 'outliercolor'};
    
    % Iterate through these fields
    for k = 1:numel(coltypes)
        
        % Current field and colour spec
        thistype  = coltypes{k};
        thesecols = opt.(thistype);

        % Is the colour spec an RGB array?
        if size(thesecols, 2) == 3
            
            % If so, is only one colour specified?
            if size(thesecols, 1) == 1, use(j).(thistype) = thesecols(1, :); %#ok<ALIGN>
                
                % Is one colour per box specified
            elseif size(thesecols, 1) == nbox, use(j).(thistype) = thesecols(j, :);
                
                % Throw an error if it's not 1 or nbox
            else error(['Inappropriate number of RGB entries specified for ' thistype]); end
            
            % Is the colour spec a cell array?
        elseif iscell(thesecols)
            
            % If so, is only one colour specified?
            if numel(thesecols) == 1, use(j).(thistype) = thesecols{1}; %#ok<ALIGN>
            
                % Is one colour per box specified
            elseif numel(thesecols) == nbox, use(j).(thistype) = thesecols{j};
                
                % Throw an error if it's not 1 or nbox
            else error(['Inappropriate number of char entries specified for ' thistype]); end
            
            % Is the colour spec a single character? (e.g. 'k' or 'b')
        elseif ischar(thesecols) && numel(thesecols) == 1, use(j).(thistype) = thesecols;
            
            % If anything else throw an error
        else error(['Colour scheme for ' thistype ' not recognised'])
        end 
    end
    
    % Easy reference the colours to be used
    mcol = use(j).mediancolor;  wcol = use(j).whiskercolor; fcol = use(j).fillcolor;
    lcol = use(j).linecolor;    dcol = use(j).datacolor;    ocol = use(j).outliercolor;
    
    % Set the x axis points
    xwhiskers = [j-wwidth j+wwidth];
    xbox      = [j-bwidth j+bwidth];
    xmedian   = [j-mwidth j+mwidth];
    
    % Also get y axis points for filled box
    ybox = [lowerqrtile(j) upperqrtile(j)];
    
    % Vertices of filled box
    xboxfill = [xbox(1) xbox(1) xbox(2) xbox(2)];
    yboxfill = [ybox(1) ybox(2) ybox(2) ybox(1)];
    
    % Do the filling
    fill(xboxfill, yboxfill, fcol)
    
    % Plot the data points
    plot(j, data(~allout(:, j), j), dshape, 'color', dcol, 'markerfacecolor', dcol, 'markersize', dsize);
    
    % Current outliers
    currout = data(allout(:, j), j);
    
    % Plot them if they exist
    if ~isempty(currout), plot(j, currout, oshape, 'color', ocol, 'markerfacecolor', ocol, 'markersize', osize); end
    
    % Horizontal quartiles
    line(xbox, repmat(upperqrtile(j), 1, 2), 'color', lcol, 'linewidth', sthick);
    line(xbox, repmat(lowerqrtile(j), 1, 2), 'color', lcol, 'linewidth', sthick);
    
    % Vertical quartiles
    line(repmat(xbox(1), 1, 2), ybox, 'color', lcol, 'linewidth', sthick);
    line(repmat(xbox(2), 1, 2), ybox, 'color', lcol, 'linewidth', sthick);
    
    % Vertical whiskers
    line(repmat(j, 1, 2), [upperwhisker(j) upperqrtile(j)], 'color', lcol, 'linewidth', sthick);
    line(repmat(j, 1, 2), [lowerwhisker(j) lowerqrtile(j)], 'color', lcol, 'linewidth', sthick);
    
    % Horizontal whiskers
    line(xwhiskers, repmat(upperwhisker(j), 1, 2), 'color', wcol, 'linewidth', wthick);
    line(xwhiskers, repmat(lowerwhisker(j), 1, 2), 'color', wcol, 'linewidth', wthick);
    
    % Horizontal median
    line(xmedian, repmat(median(j), 1, 2), 'color', mcol, 'linewidth', mthick);
    line(xmedian, repmat(median(j), 1, 2), 'color', mcol, 'linewidth', mthick);
end

% Finally, set the xticks to only the relevant integers
set(gca, 'xtick', 1:nbox);


%% Nested function -- use default colour system
%
% Looks nice for around 10 boxes, then starts to get a bit too much
    function col = defaultcols(nbox, coltype)
        
        % Switch case for type of colours
        switch coltype 
            
            case 'main' % Main outline colours
                
                % Colour matrix
                colmat = (1/255) .* [ ...
                    235 97  41;  ... Orange outline
                    246	203	60;  ... Yellow outline
                    71  149 195; ... Blue outline
                    73  152 61;  ... Green outline
                    247 65  66]; %   Red outline
                
            case 'fill' % Fill colours
                
                % Colour matrix
                colmat = (1/255) .* [ ...
                    255 127 70;  ... Orange fill
                    255 238 96;  ... Yellow fill
                    91  186 237; ... Blue fill
                    59  213 45;  ... Green fill
                    255 98  96]; %   Red fill
                
                % Line case is simple --- return straight out
            case 'line', col = [.5 .5 .5]; return;
                
                % Data case is simple --- return straight out
            case 'data', col = [.3 .3 .3]; return;
                
                % Data case is simple --- return straight out
            case 'out', col = 'k'; return;
                
                % Throw an error if I've done something stupid
            otherwise, error(['Case ' num2str(coltype) ' not recognised'])
        end
        
        % Number of default colours
        ndef = size(colmat, 1);
        
        % Resize the number of colours if nbox is less than the number of defaults
        if nbox <= ndef, col = colmat(1:nbox, :); else

            % Preallocate array to store all the colours
            col = zeros(nbox, size(colmat, 2));
            
            % Number of colours to repeat
            repcol = nbox - ndef;
            
            % How many times is the defult colour block to be repeated
            for l = 1:floor(repcol / ndef) + 1
                
                % Set the entire colour block an appropriate number of times
                col((ndef * (l-1) + 1):(ndef * l), :) = colmat;
            end
            
            % Finally, repeat any colour to complete the array
            col((ndef * l + 1):end, :) = colmat(1:mod(repcol, ndef), :);
        end
    end


end

