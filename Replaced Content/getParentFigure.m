function fig = getParentFigure(obj)
% GETPARENTFIGURE finds the figure containing the specified object.
%
%   See also getParentAxes getParentType 
%
%   (c) M. Kutzer 17July2015, USNA

fig = getParentType(obj,'figure');