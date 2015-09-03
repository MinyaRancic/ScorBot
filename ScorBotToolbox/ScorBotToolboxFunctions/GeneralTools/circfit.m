function   [xc,yc,R,a] = circfit(x,y)
% CIRCFIT find the best fit circle given a set of 2D points
%   [xc,yc,R] = CIRCFIT(x,y) find the center and radius of a best fit
%   circle to a set of 2D points.
%       x - N-element array containing points in the first dimension
%       y - N-element array containing points in the second dimension
%       xc - circle center point in the first dimension
%       yc - circle center point in the second dimension
%       R - circle radius
%
%   [xc,yc,R,a] = CIRCFIT(x,y) includes an optional output vector "a" of
%   coefficients to the equation describing the circle.
%       x^2+y^2+a(1)*x+a(2)*y+a(3)=0
%
%   NOTE: This function fits a circle in the x,y plane in a more accurate
%       (less prone to ill condition ) procedure than circfit2 but using 
%       more memory.
%
%   Original Fuction By:  Izhak bucher 25Oct1991
%   http://www.mathworks.com/matlabcentral/fileexchange/5557-circle-fit/content//circfit.m
%
%   Updated: M. Kutzer, 14Aug2015

x = reshape(x,[],1);
y = reshape(y,[],1);
a = [x,y,ones(size(x))]\[-(x.^2+y.^2)];

xc = -.5*a(1);
yc = -.5*a(2);
R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));