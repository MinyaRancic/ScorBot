function pln = fitPlane(pnts)
% FITPLANE fits the equation of a plane (a*x + b*y + c*z + d = 0) to a 
% series of points. Coefficients are calculated in the Hessian normal form
% using the left singluar vector correcponding to the least singular value
% to determine the unit normal.
%   pln = FITPLANE(pnts) This function fits the equation of a plane 
%   (a*x + b*y + c*z + d = 0) to a series of points. Coefficients are 
%   calculated in the Hessian normal form using singular value 
%   decomposition to determine the unit normal.
%
%       pnts - 3xN array containing points
%       pln - 1x4 array containing coefficients for plane equation 
%           [a,b,c,d] such that a*x + b*y + c*z + d = 0
%
%   References
%   [1] http://mathworld.wolfram.com/Plane.html
%   [2] http://math.stackexchange.com/questions/99299/best-fitting-plane-given-a-set-of-points
%
%   See also 
%
%   (c) M. Kutzer 10July2015, USNA

%% check inputs
[m,n] = size(pnts);
if m ~= 3
    error('Points must be specified in 3D');
end
if n < 3
    error('Atleast 3 points must be specified to define a plane');
end

%% eliminate/ignore non-finite values
[~,j] = find(~isfinite(pnts));
pnts(:,j) = [];

%% define plane
N = size(pnts,2);
cg = (1/N)*sum(pnts,2);

%TODO - eliminate use of svd twice by actually looking at the values in the
%second output of the first call
[u,~,~] = svd( bsxfun(@minus,pnts,cg) );
s = svd( bsxfun(@minus,pnts,cg) );
idx = find(s == min(s),1);

n = u(:,idx);   % unit normal
p = -n'*cg;     % intercept

pln = zeros(1,4);
pln(1:3) = n;
pln(4) = p;

