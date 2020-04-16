
x_guess=[1.5; 1.5; 1; .5; 1; .7; .5; .5]; 
phi = 2.5;
Ns = [.5:.02:1];
solns=zeros(8, length(Ns));

for i=1:length(Ns)
[soln, min_val]= fminsearch(@(devs) extensive_eqns(devs, Ns(i), phi), x_guess);
solns(:,i) = soln;
end;
solns = solns';
solns = [solns Ns'];
csvwrite('sim_results_extensiveCapital.csv', solns)