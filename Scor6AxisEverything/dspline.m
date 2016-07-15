function dpp = dspline(pp)
% DSPLINE differentiate piecewise polynomial
%   dpp = DSPLINE(pp) differentiates piecewise polynomial "pp".
%
%   M. Kutzer, 01May2016, USNA

[breaks,coeffs,~,~,~] = unmkpp(pp);

dcoeffs = coeffs * diag( [(size(coeffs,2)-1):-1:0] );

dpp = mkpp(breaks,dcoeffs(:,1:3));