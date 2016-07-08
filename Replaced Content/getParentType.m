function mom = getParentType(obj,ptype)
% GETPARENTTYPE finds the first parent in the ancestry of obj  
% containing the specified object.
%   
%   (c) M. Kutzer 17July2015, USNA

% Updates:
%   14Aug2015 - Updated to check inputs

%% Check inputs
if ~ishandle(obj)
    error('First argument must be a valid handle.');
end
if ~ischar(ptype)
    error('Parent type must be a character string.');
end

%% Get parent type
mom = obj;
while ~strcmpi( get(mom,'type'), ptype );
    mom = get(mom,'Parent');
    if strcmpi( get(mom,'type'), 'root' ) && ~strcmpi( ptype, 'root' )
        warning( sprintf('No parent of type "%s" found.',ptype) );
        mom = [];
        break
    end
end
