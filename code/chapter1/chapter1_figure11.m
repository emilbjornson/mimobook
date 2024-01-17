%This Matlab script can be used to reproduce Figure 1.11 in the textbook:
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

%% Compute the antenna gain in different directions
varphi = linspace(-pi,pi,1000);
antennagain = 4*cos(varphi);

%Removing the negative part
antennagain(antennagain<0) = 0;


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(antennagain),'-b','LineWidth',2)
plot(varphi/pi,zeros(size(antennagain)),'k--','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-1 -0.75 -0.5, -0.25, 0, 0.25, 0.5 0.75 1]);
xticklabels({'$-\pi$','$-\frac{3\pi}{4}$','$-\frac{\pi}{2}$','$-\frac{\pi}{4}$','$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$','$\frac{3\pi}{4}$','$\pi$'});
ylim([-10 10]);
xlabel('Azimuth angle $\varphi$','Interpreter','latex');
ylabel('Antenna gain [dBi]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'Cosine','Isotropic'},'Interpreter','latex');
