%% SAVE VERSION FIGURE
%
% Rather than overwrite a figure that has the same file name, this
% function will save the figure with the same name but will append a v\d.
% That is 'v' followed by a value x, where x is 1 greater than the greatest
% current version number of the figure to be created.
%
% Uses the saveas function to do the hard work.
%
% Written by A.J.Shattock - Feb 2015

function savefigv(figname, varargin)
    
    % -- Get file extension -- %
    
    % For now we'll only accept a single additional argument
    assert(numel(varargin) <= 1, 'Too many input arguments')
    
    % Get the file name parts in seperate strings
    [fpath, fname, fext] = fileparts(figname); % path, name and extension
    
    % Use extra input argument if it's given for file extension
    if ~isempty(varargin), fformat = varargin{1};
        
        % Throw an error if file extension is also defined in figname
        assert(isempty(fext), 'Multiple file extensions are defined');
    else
        
        % Use file extension from figname if given, or use .fig as default
        if ~isempty(fext), fformat = fext; else fformat = 'fig'; end
    end
    
    
    %% Determine next version of figure
    
    % Store the current directory to move back at the end
    origdir = cd;
    
    % Change folders to fpath if it's not where we currently are
    if ~isempty(fpath), cd(fpath); end
    
    % Use nested function to find next version
    thisversion = findversion(fname, fformat);
    
    % Concatenate version number within file name
    vname = [fname ' v' num2str(thisversion)];
    
    
    %% Save the figure
    
    % Use the same as function to save the file
    saveas(gcf, vname, fformat);
    
    % Return to original folder if we moved out
    if ~strcmp(pwd, origdir), cd(origdir); end
    
    
    %% NESTED FUNCTION -- FIND VERSION
    %
    % Find next version of current figure to be saved
    function thisver = findversion(fname, fformat)
        
        % String to search for given format
        fstr = ['.' fformat];
        
        % Regular expression to find version
        verfind = [fname ' v\d+'];
        
        % List all the files in the current directory
        listfiles = ls; nfiles = size(listfiles, 1); allv = 0; nvers = 0;
        
        % Set the strings inside cells and remove padding spaces
        for i = 1 : nfiles
            
            % Current filename being examined
            thisfile = listfiles(i, :);
            
            % Does this file have the appropriate extension
            exext = strfind(thisfile, fstr);
            
            % It does - trim the file name to investigate further
            if ~isempty(exext), tfile = thisfile(1:exext - 1);
                
                % Does the file name match too?
                regfind = regexp(tfile, verfind, 'once');
                
                % If it does, we'll need to extract the version number
                if ~isempty(regfind), nvers = nvers + 1;
                    
                    % Character location of version number
                    verloc = regexp(tfile, 'v\d+');
                    
                    % Store the version number in a vector that we'll inspect at the end
                    allv(1, nvers) = str2double(tfile(verloc + 1:end)); %#ok<AGROW>
                end
            end
        end
        
        % We've been through all the files - were there matches, and what was the highest match
        if max(allv) == 0, thisver = 1; else thisver = max(allv) + 1; end
    end
    
    
end

