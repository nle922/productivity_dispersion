
beta = 1/1.03; sigma=4; gamma=.97; sigmaA=.26; A=-6;
pi = .33; nu=5.584; xi=.003;

phiVals = [20:.1:40]; Yvals=zeros(length(phiVals),1); Dvals = zeros(length(phiVals),1); corrRQvals = zeros(length(phiVals),1); TFPvals = zeros(length(phiVals),1); Nvals=zeros(length(phiVals),1); equityAssets = zeros(length(phiVals),1);

for i=1:length(phiVals)
[rhoQR, N, sigmaR, aBar, L, TFP, Y, w, D, C]=calc_steadystate(xi, beta, sigma, gamma, sigmaA, phiVals(i), pi,nu, A);
Yvals(i) = log(Y);
Dvals(i)=log(D);
corrRQvals(i) = rhoQR;
TFPvals(i) = log(TFP);
Nvals(i) = log(N);
equityAssets(i) = N/(w*L);
end;