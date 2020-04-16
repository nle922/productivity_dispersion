function quad_dev = extensive_eqns(x, N, phi)

Rf = x(1);
Rb = x(2);
Ahat = x(3);
rhoQR = x(4);
Abar = x(5);
logA = x(6);
sigmaQ = x(7);
sigmaR = x(8);

%phi = 2.5;
sigma = 4;
%N = 1;
 
dev =zeros(8,1);

%we are choosing a particular set of values for parameters of log A
%distribution. need to adjust these equations if going to consider other
%cases.
dev(1) = ((Rf-Rb)/(phi-Rb))-normcdf((sigma-1)/sigma * log(Rb));
dev(2) = 1 + (Rf-Rb)/phi - Ahat^((sigma-1)/sigma)*(N*Rf)^(-sigma);
dev(3) = rhoQR - ((sigma-1)/(sigma + (Ahat^(1-sigma)*(N*Rf)^(sigma+1))/phi));
dev(4) = log(Ahat) - .5*rhoQR - (1/rhoQR)*log(normcdf(rhoQR - ((sigma-1)/sigma)*log(Rb)/rhoQR));
dev(5) = log(Rb)+log(N) - (sigma-1)/sigma * log(Abar);
dev(6) = logA - normpdf(log(Abar))/(1-normcdf(log(Abar)));
dev(7) = sigmaQ - 1+(normpdf(log(Abar))/(1-normcdf(log(Abar))))^2;
dev(8) = sigmaR -sigmaQ*rhoQR; 

quad_dev = dev'*dev;