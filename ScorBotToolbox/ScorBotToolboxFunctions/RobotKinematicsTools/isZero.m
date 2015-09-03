function bin = isZero(M,ZERO)
%isZero checks each element of an array to see if it zero. If all elements
%are zero, isZero returns a "1" and "0" otherwise.
%   isZero(M,ZERO) checks each element of an arbitrary array M against a
%   specified value for zero. If no value for zero is specified, a default
%   value is specified using the class of M and the spacing of floating
%   point numbers for that associated class (using eps.m).
%
%   See also zeroFPError eps
%
%   (c) M. Kutzer 13May2015, USNA


%% Set default zero
if nargin < 2
    ZERO = 10*eps(class(M));
end

%% Check if a matrix is effectively zero
for i = 1:numel(M)
    %TODO - make this faster
    if abs(M(i)) > ZERO
        bin = 0;
        return
    end
end

bin = 1;