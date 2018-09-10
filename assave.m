%% A.S. SAVE
%
% Matlab has gone bonkers and can't seem to render figures properly. This is my
% work around.
%
% Written by Roo - November 2015

function assave(fname)

% Set a white background
set(gcf, 'color', 'w');

% Convert current figure into a frame
cf = getframe(gcf);

% Write the cdata of the frame to a .png file
imwrite(cf.cdata, [fname '.png'])

