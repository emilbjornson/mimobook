%This Matlab script can be used to reproduce Figure 2.22 in the textbook:
%Emil Bjornson and Ozlem Tugfe Demir (2024),
%"Introduction to Multiple Antenna Communications and Reconfigurable Surfaces", 
%Boston-Delft: Now Publishers, http://dx.doi.org/10.1561/9781638283157
%
%This is version 1.0 (Last edited: 2024-01-17)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%textbook as described above. You can find the complete code package at
%https://github.com/emilbjornson/mimobook

close all;
clear;

seed = 66;
rng(seed);

%Set number of samples
L = 100;

%Define sigma^2 parameter
sigma2 = 1;

%Generate L realizations of Rayleigh(sqrt(sigma2/2))
xRealizations = raylrnd(sqrt(sigma2/2),L,1);


%Compute the exact CDF
a = linspace(0,3,100);
fx = 1-exp(-a.^2/sigma2);




%Create an empirical CDF
eXaxis = sort([0; xRealizations; xRealizations; max(a)]);
eYaxis = sort([linspace(0,1,L+1) linspace(0,1,L+1)])';


%Determine the standard deviation of the estimates
fx_eYaxis = 1-exp(-eXaxis.^2/sigma2);
stdEstimates = sqrt((fx_eYaxis.*(1-fx_eYaxis))/L);

%Compute the limits of the confidence interval using the Gaussian
%approximation with two standard deviations
fx_lower = eYaxis-2*stdEstimates;
fx_upper = eYaxis+2*stdEstimates;
fx_upper(fx_upper>1) = 1; %The CDF value can never be larger than 1

%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  


figure;
hold on; box on; grid on;
plot(a,fx,'b:','LineWidth',2);
plot(eXaxis,eYaxis,'r-','LineWidth',2);
plot(eXaxis,fx_lower,'k--','LineWidth',2);
plot(eXaxis,fx_upper,'k--','LineWidth',2);

h = area(eXaxis, [fx_lower fx_upper-fx_lower],0);
set(h(1), 'FaceColor', 'none');
set(h, 'LineStyle', 'none');
h(2).FaceColor = [0.95 0.95 0.95];

plot(a,fx,'b:','LineWidth',2);
plot(eXaxis,eYaxis,'r-','LineWidth',2);
plot(eXaxis,fx_lower,'k--','LineWidth',2);
plot(eXaxis,fx_upper,'k--','LineWidth',2);

xlabel('$x$','Interpreter','latex');
ylabel('Cumulative distribution function','Interpreter','latex');
legend({'CDF $F_X(x)$','eCDF $\hat{F}_{X,L}(x)$','Confidence interval'},'Interpreter','latex','Location','SouthEast');
set(gca,'fontsize',16);
ylim([0 1]);
