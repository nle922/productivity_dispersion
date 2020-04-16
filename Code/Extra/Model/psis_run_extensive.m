
x_guess=[1.5; 1.5; 1; .5; 1; .7; .5; .5]; 
phis = [2.5: .1: 5];
N = .5;
solns=zeros(8, length(phis));

for i=1:length(phis)
[soln, min_val]= fminsearch(@(devs) extensive_eqns(devs, N, phis(i)), x_guess);
solns(:,i) = soln;
end;
solns = solns';
solns = [solns phis'];
csvwrite('sim_results_extensive.csv', solns)
