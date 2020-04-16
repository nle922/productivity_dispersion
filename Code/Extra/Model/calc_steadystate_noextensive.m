function [rhoQR, N, sigmaR, aBar, L, TFP, Y, w, D, C]=calc_steadystate(xi, beta, sigma, gamma, sigmaA, phi, pi,nu, A);

sigmaR = (beta*phi*(sigma-1)*sigmaA-sqrt(2*phi*(xi+gamma+(gamma/(2*beta))+1)))/(beta*sigma*phi);
N = sqrt(2*phi*(xi+gamma+(gamma/(2*beta))+1))/sigmaR;

rhoQR=sigmaR/sigmaA;
aBar = exp(.5*sigmaA^2*(sigma-1)/((N/(beta*phi))+sigma));
L = exp( log(N/beta) - ((sigma-1)/sigma)*log(aBar));
TFP = exp(A+(sigma-1)*.5*sigmaA^2 - sigma*.5*sigmaR^2-rhoQR*sigmaR*sigmaA*(sigma-1));
Y = TFP*L;
w=nu*L^(pi)*Y;
D=L*w-N;
C=Y;