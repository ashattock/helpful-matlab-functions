%% A.S. STRUCT
%
% Append all fields of a temporary structure directly to a structure array.
%
% Useage:
%   for i=1:n, tmpstruct=load('stuff.mat'); mystruct=asstruct(mystruct,tmpstruct,i); end
%
% Written by Roo - Feb 2015

function appstruct = asstruct(appstruct, tmpstruct, ind)


%% Sanity checks

% Set some sanity check conditions on input arguments
sc1 = isstruct(appstruct);
sc2 = isstruct(tmpstruct) && ~isempty(fieldnames(tmpstruct));
sc3 = mod(ind, 1) == 0 && ind > 0;

% Assert that these conditions hold true
assert(sc1, 'First input must be a structure - empty or not')
assert(sc2, 'Second input must be a non-empty structure')
assert(sc3, 'Third input must be a non-zero integer')


%% Append to new structure

% Field names in temp structure
fnames = fieldnames(tmpstruct);

% Number of fields in temp structure
nfields = numel(fnames);

% Iterate through the fields
for i = 1:nfields
    
    % Current field
    thisfield = fnames{i};
    
    % Append form temp structure to new structure
    appstruct(ind).(thisfield) = tmpstruct.(thisfield);
end

