function axs = getParentAxes(obj)
% GETPARENTAXES finds the axes containing the specified object.
%
%   See also getParentFigure getParentType 
%
%   (c) M. Kutzer 17July2015, USNA

axs = getParentType(obj,'axes');