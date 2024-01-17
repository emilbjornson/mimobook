%This Matlab script can be used to reproduce Figure 2.19 in the textbook:
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


%Set seed number to 9 for Figure 2.19(a) and 18 for Figure 2.19(b)
seed = 9;
rng(seed)

%Set maximum number of samples
L = 1000;

%Set the range of number of samples
Lrange = (1:L)';


%Generate random realizations from exponential distributions


h = (randn(L,1)+1i*randn(L,1))/sqrt(2);
h2 = cumsum(abs(h).^2)./Lrange;
    
%Determine confidence interval using Gaussian approximation
lower_interval_Gaussian = h2-2./sqrt(Lrange);
upper_interval_Gaussian = h2+2./sqrt(Lrange);


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;

plot(Lrange,ones(size(Lrange)),'b:','LineWidth',2);
plot(Lrange,h2,'r-','LineWidth',2);
plot(Lrange,lower_interval_Gaussian,'k--','LineWidth',2);
plot(Lrange,upper_interval_Gaussian,'k--','LineWidth',2);

xlabel('Number of samples ($L$)','Interpreter','latex');
ylabel('Mean value','Interpreter','latex');
set(gca,'fontsize',16);
ylim([0 2]);

y = [lower_interval_Gaussian'; upper_interval_Gaussian'-lower_interval_Gaussian']';
h = area(Lrange, y, 0);
set(h(1), 'FaceColor', 'none');
set(h, 'LineStyle', 'none');
h(2).FaceColor = [0.95 0.95 0.95];

plot(Lrange,ones(size(Lrange)),'b:','LineWidth',2);
plot(Lrange,lower_interval_Gaussian,'k--','LineWidth',2);
plot(Lrange,h2(:,1),'r-','LineWidth',2);
plot(Lrange,upper_interval_Gaussian,'k--','LineWidth',2);


legend({'Exact $\mu$','Estimate $\hat{\mu}_L$','Confidence interval'},'Interpreter','latex');

