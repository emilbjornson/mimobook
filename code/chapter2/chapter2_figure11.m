%This Matlab script can be used to reproduce Figure 2.11 in the textbook:
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


%Set range of time axis
t = -5:0.01:5;

%Compute sinc function
y = sinc(t);

%Set range of frequency axis
f = -3:0.01:3;

%Compute box function
yFourier = abs(f)<=1/2;



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(t,y,'-b','LineWidth',2)
ax = gca;
set(ax, 'XTick', -5:5);
xticklabels({'$-\frac{5}{B}$','$-\frac{4}{B}$','$-\frac{3}{B}$','$-\frac{2}{B}$','$-\frac{1}{B}$','$0$','$\frac{1}{B}$','$\frac{2}{B}$','$\frac{3}{B}$','$\frac{4}{B}$','$\frac{5}{B}$'})
set(ax, 'YTick', -0.5:0.5:1);
yticklabels({'$-\frac{\sqrt{B}}{2}$','$0$','$\frac{\sqrt{B}}{2}$','$\sqrt{B}$'})
xlabel('Time $t$ [s]','Interpreter','latex');
ylabel('$\sqrt{B}\mathrm{sinc}(Bt)$','Interpreter','latex');
set(gca,'fontsize',16);
ylim([-0.5 1]);

%% Plot the simulation results
figure;
hold on; box on; grid on;
plot(f,yFourier,'-b','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-3:-1 -0.5 0 0.5 1:3]);
xticklabels({'$-3B$','$-2B$','$-B$','$-\frac{B}{2}$','$0$','$\frac{B}{2}$','$B$','$2B$','$3B$'})
set(ax, 'YTick', 0:0.5:1);
yticklabels({'$0$','$\frac{1}{2\sqrt{B}}$','$\frac{1}{\sqrt{B}}$'})
xlabel('Frequency $f$ [Hz]','Interpreter','latex');
ylabel('Fourier transform of $\sqrt{B}\mathrm{sinc}(Bt)$','Interpreter','latex');
set(gca,'fontsize',16);
ylim([0 1.1]);
