function ipp = ispline(pp,c)
% ISPLINE integrate piecewise polynomial
%   ipp = ISPLINE(pp) integrates piecewise polynomial "pp" assuming an
%   initial condition of 0.
%
%   ipp = ISPLINE(pp,c) integrates piecewise polynomial "pp" assuming an
%   initial condition of "c".
%
%   M. Kutzer, 01May2016, USNA

if nargin < 2
    c = 0;
end

[breaks,coeffs,~,~,~] = unmkpp(pp);
icoeffs = coeffs * diag( [size(coeffs,2):-1:1] )^(-1);
icoeffs(:,5) = c;

ipp = mkpp(breaks,icoeffs);
