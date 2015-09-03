function h = showTriad(h)
% SHOWTRIAD shows the x, y, and z-direction and labels of the specified
% triad object (a transform object with three orthogonal lines as 
% children).
%   SHOWTRIAD(h) shows the visualization of the axes associated with the
%   transform object(s) specified in h. Multiple objects must be specified
%   in an array.
%
%   See also hgtransform triad hideTriad showTriadLabels hideTriadLabels
%
%   (c) M. Kutzer 19Dec2014, USNA

%Updates
%   13May2015 - Updated definition for multiple triads and extended 
%               documentation
%   13Aug2015 - Updated to include triad labels

%%
axs_tags = {'X-Axis','Y-Axis','Z-Axis'};
for i = 1:numel(h)
    kids = get(h(i),'Children');
    for j = 1:numel(axs_tags)
        idx = find(~cellfun(@isempty, strfind(get(kids,'Tag'),axs_tags{j})));
        for k = 1:numel(idx)
            if strcmpi( get(kids(idx(k)),'Type'), 'Line' )
                set(kids(idx(k)),'Visible','on');
            end
        end
    end
end
