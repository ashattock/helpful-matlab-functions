%% THOU SEPARATOR
%
% Matlab doesn't seem to have a built-in thousands-separator function...
% so this little function is here to save the day.
%
% Written by A.J.Shattock - February 2014

function separated_string = thousep(varargin)
    
    % Specidy inputs as variables
    if nargin == 1, unseparated_value = varargin{1}; rounding = 1; end
    if nargin == 2, unseparated_value = varargin{1}; rounding = varargin{2}; end
    
    % A few sanity checks for the number of inputs
    if nargin == 0, error('Not enough inputs'); end
    if nargin > 2,  error('Too many inputs'); end
    
    % Set input to positive to perform everything (convert back at the end)
    if unseparated_value < 0, unseparated_value = unseparated_value * - 1; end
    
    % If rounding to the nearest 'rounding'
    if rounding > 1
        
        % A few conditions on rounding
        assert(mod(log10(rounding), 1) == 0, 'Round term must be of the form 10^n');
        %     assert(rounding <= unseparated_value, 'Round larger than input value');
        
        % Round the value to nearest 'rounding'
        unseparated_value = round(unseparated_value / rounding) * rounding;
        
        % If rounding to decimal places
        %
        % NOTE: rounding = 1 has no effect
    elseif rounding < 1
        
        % A conditions on rounding to nearest decimal place
        assert(mod(log10(rounding), 1) == 0, 'Decimal term must be of the form 10^-n');
        
        % Form a string for the decimal part
        decimal_string = num2str(round((round(unseparated_value / rounding) * ...
            rounding - floor(unseparated_value)) / rounding) * rounding);
        
        % Take out the leading 0
        decimal_string = decimal_string(2:end);
        
        % Redefine as an integer
        unseparated_value = floor(unseparated_value);
        
        % If rounding is 0, we don't want floor, we want ceil!
        %     if isempty(decimal_string), unseparated_value = unseparated_value + 1; end
    end
    
    % Round value and form as a string (in reverse)
    reverse_string = sprintf(',%c%c%c', fliplr(num2str(round(unseparated_value))));
    
    % Flip value back around, and cut any unnecessary separators
    separated_string = fliplr(reverse_string(2:end));
    
    % Tack on the decimal part if appropriate
    if rounding < 1, separated_string = [separated_string decimal_string]; end
    
    % Tack on minus sign if appropriate
    if varargin{1} < 0, separated_string = ['-' separated_string]; end
end

