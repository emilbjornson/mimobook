%This Matlab script can be used to reproduce Figure 2.23 in the textbook:
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

seed = 0;
randn(seed)

%Set number of samples
L = 1000;

%Define the considered sigma2 parameters
sigma2 = [1 2];

%Generate L realizations of Rayleigh(sqrt(sigma2/2))
xRealizations1 = raylrnd(sqrt(sigma2(1)/2),L,1);
xRealizations2 = raylrnd(sqrt(sigma2(2)/2),L,1);


%Create the empirical CDFs
eXaxis1 = sort([0; xRealizations1; xRealizations1; 3]);
eXaxis2 = sort([0; xRealizations2; xRealizations2; 3]);
eYaxis = sort([linspace(0,1,L+1) linspace(0,1,L+1)])';




%Determine the standard deviation of the estimates
fx_eXaxis1 = 1-exp(-eXaxis1.^2/sigma2(1));
fx_eXaxis2 = 1-exp(-eXaxis2.^2/sigma2(2));

stdEstimates1 = sqrt((fx_eXaxis1.*(1-fx_eXaxis1))/L);
stdEstimates2 = sqrt((fx_eXaxis2.*(1-fx_eXaxis2))/L);



%Compute the limits of the confidence intervals using the Gaussian
%approximation with two standard deviations
fx1_lower = eYaxis-2*stdEstimates1;
fx1_upper = eYaxis+2*stdEstimates1;
fx2_lower = eYaxis-2*stdEstimates2;
fx2_upper = eYaxis+2*stdEstimates2;





%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(eXaxis1,eYaxis,'r-','LineWidth',2);
plot(eXaxis2,eYaxis,'b-.','LineWidth',2);
plot(eXaxis1,fx1_lower,'k--','LineWidth',2);


h = area(eXaxis1, [fx1_lower fx1_upper-fx1_lower],0);
set(h(1), 'FaceColor', 'none');
set(h, 'LineStyle', 'none');
h(2).FaceColor = [0.95 0.95 0.95];


h = area(eXaxis2, [fx2_lower fx2_upper-fx2_lower],0);
set(h(1), 'FaceColor', 'none');
set(h, 'LineStyle', 'none');
h(2).FaceColor = [0.95 0.95 0.95];

plot(eXaxis1,eYaxis,'r-','LineWidth',2);
plot(eXaxis2,eYaxis,'b-.','LineWidth',2);

plot(eXaxis1,fx1_lower,'k--','LineWidth',2);
plot(eXaxis1,fx1_upper,'k--','LineWidth',2);
plot(eXaxis2,fx2_lower,'k--','LineWidth',2);
plot(eXaxis2,fx2_upper,'k--','LineWidth',2);

xlabel('$x$','Interpreter','latex');
ylabel('Cumulative distribution function','Interpreter','latex');
legend({'eCDF $\hat{F}_{Y,L}(x)$','eCDF $\hat{F}_{Z,L}(x)$','Confidence interval'},'Interpreter','latex','Location','SouthEast');
set(gca,'fontsize',16);
xlim([0 3]);
ylim([0 1]);
