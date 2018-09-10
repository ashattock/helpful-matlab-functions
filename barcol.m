%% BAR COL
%
% For unique colours when plotting a vector as a bar graph.
%
% Written by A.J.Shattock - Apr 2015

function h = barcol(data, cols)
    
    % Size of data
    dsize = size(data);
    
    % Sanity check on the input data argument
    assert(numel(dsize) == 2, 'Data must be 2-dimensional');
    assert(min(dsize) == 1, 'Data must be in (1 x n) vector form');
    
    % Number of data points
    ndata = max(dsize);
    
    % Diagonal matrix of data values - essentially creating mock, trivial data
    dataeye = eye(ndata) .* repmat(reshape(data, 1, ndata), ndata, 1);
    
    % Plot the data, with trivial data on top
    h = bar(dataeye, 'stacked');
    
    % Now we have ndata elements in the handle, set them to whatever colours you want
    for i = 1 : ndata, set(h(i), 'facecolor', cols(i, :)); end
end
    
