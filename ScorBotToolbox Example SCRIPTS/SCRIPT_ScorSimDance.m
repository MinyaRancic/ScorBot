%SCRIPT_ScorSimDance
% Execute a series of random joint configurations for the ScorBot simulation.
%
%   M. Kutzer 18Feb2016, USNA

sim = ScorSimInit;
ScorSimPatch(sim);

s_vec = @(s) [s; 1];
k = 1.0; % Allow movements up to a factor of k times the total distance between limits
while true
    q_init = transpose( ScorSimGetBSEPR(sim) );
    q_goal = transpose( ScorBSEPRRandom(k) );
    T = [q_init, q_goal];
    S = [s_vec(0), s_vec(1)];
    M = T*S^(-1);
    
    s = linspace(0,1,round( 30*norm(diff(T,1,2)) ));
    for s_i = s
        ScorSimSetBSEPR(sim, transpose( M*s_vec(s_i) ) );
    end
end