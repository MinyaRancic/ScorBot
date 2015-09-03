function h = hideTriadLabels(h)
% HIDETRIADLABELS hides the x, y, and z-direction labels of the specified
% triad object (a transform object with three orthogonal lines as 
% children).
%   HIDETRIADLABELS(h) hides the axes labels associated with the transform 
%   object(s) specified in h. Multiple objects must be specified in an 
%   array.
%
%   See also hgtransform triad hideTriad showTriad showTriadLabels 
%
%   (c) M. Kutzer 13Aug2015, USNA

%%
axs_lbls = {'X-Label','Y-Label','Z-Label'};
for i = 1:numel(h)
    kids = get(h(i),'Children');
    for j = 1:numel(axs_lbls)
        idx = find(~cellfun(@isempty, strfind(get(kids,'Tag'),axs_lbls{j})));
        for k = 1:numel(idx)
            if strcmpi( get(kids(idx(k)),'Type'), 'Text' )
                set(kids(idx(k)),'Visible','off');
            end
        end
    end
end