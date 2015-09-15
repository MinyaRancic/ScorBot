function varargout = ScorVer
% SCORVER displays the ScorBot Toolbox information.
%   SCORVER displays the information to the command prompt.
%
%   A = SCORVER returns in A the sorted struct array of version information
%   for the ScorBot Toolbox.
%     The definition of struct A is:
%             A.Name      : toolbox name
%             A.Version   : toolbox version number
%             A.Release   : toolbox release string
%             A.Date      : toolbox release date
%
%   (c) M. Kutzer 25Aug2015, USNA

% Updates
%   26Aug2015 - Updated to include "ScorUpdate.m" and minor documentation
%               changes.
%   28Aug2015 - Maintain speed or movetime using ScorGetSpeed and
%               ScorGetMoveTime
%   28Aug2015 - Updated error handling
%   15Sep2015 - Updates to ScorWaitForMove, ScorSafeShutdown,
%               ScorSetPendantMode, ScorIsReady, ScorDispError, and 
%               ScorParseErrorCode to address existing bugs, add a timeout
%               to ScorWaitForMove, and add enable/disable display
%               capabilities to ScorDispError and ScorIsReady for
%               non-critical errors (e.g. 970 and 971).

A.Name = 'ScorBot Toolbox';
A.Version = '2.1.5';
A.Release = '(R2014a)';
A.Date = '15-Sept-2015';
A.URLVer = 1;

msg{1} = sprintf('MATLAB %s Version: %s %s',A.Name, A.Version, A.Release);
msg{2} = sprintf('Release Date: %s',A.Date);

n = 0;
for i = 1:numel(msg)
    n = max( [n,numel(msg{i})] );
end

fprintf('%s\n',repmat('-',1,n));
for i = 1:numel(msg)
    fprintf('%s\n',msg{i});
end
fprintf('%s\n',repmat('-',1,n));

if nargout == 1
    varargout{1} = A;
end