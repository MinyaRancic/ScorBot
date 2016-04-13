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
%   25Sep2015 - Updates to ScorSim* including ScorSimPatch
%   25Sep2015 - Ignore isReady in ScorGetXYZPR and ScorGetBSEPR to allow
%               users to read joints even with errors.
%   29Sep2015 - Updates to installScorBotToolbox and ScorUpdate to allow
%               non-Windows 32-bit OS to install simulation tools. 
%               Additional updates to fix bugs in simulation tools.
%   01Oct2015 - Updates to ScorSim* error checking.
%   04Oct2015 - Updates to include ScorSimSetGripper and ScorSimGetGripper
%               functionality.
%   05Oct2015 - Example and test SCRIPT update including update to
%               ScorUpdate.
%   14OCt2015 - Created ScorXYZPRJacobian function.
%   23Oct2015 - Updates to ScorSim* to include XYZPR and BSEPR teach modes. 
%   23Oct2015 - Update to ScorXYZPR2BSEPR to allow user to select between
%               elbow-up and elbow-down solutions.
%   23Dec2015 - Updates to XYZPR, BSEPR, and Pose input functions
%               (excluding ScorSim*) to clarify errors.
%   30Dec2015 - Added ScorSimSetDeltaPose
%   30Dec2015 - Updates to ScorSim* to clarify errors.
%   30Dec2015 - Updated ScorSimSet* to include "confirm" output
%   08Jan2016 - Error fix on ScorWaitForMove
%   13Jan2016 - Included isSkewSymmetric and Affine Transform primitives in
%       the RobotKinematicsTools.
%   31Jan2016 - Added ScorGetGripperOffset and ScorSimGetGripperOffset
%       functions to calculate the offset between the end-effector frame 
%       and the tip of the gripper.
%   27Feb2016 - Breakout into multiple toolboxes
%   13Apr2016 - Added initial UDP send/receive functionality

% TODO - Migrate affine transform tools into more descriptive folder
% TODO - Update Scor* error checking to use "mfilename"
% TODO - Update Scor* error checking to use "inputname(i)"

A.Name = 'ScorBot Toolbox';
A.Version = '3.1.0';
A.Release = '(R2014a)';
A.Date = '13-Apr-2016';
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