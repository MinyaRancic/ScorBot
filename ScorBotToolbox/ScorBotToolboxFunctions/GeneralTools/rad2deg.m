function deg = rad2deg(rad)
% RAD2DEG Convert angles from radians to degrees.
%   deg = RAD2DEG(rad) converts angle or array of angles in radians to an
%   angle or array of angles in degrees.
%
%   See also deg2rad

deg = (180/pi).*rad;