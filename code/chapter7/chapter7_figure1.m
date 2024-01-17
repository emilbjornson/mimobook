%This Matlab script can be used to reproduce Figure 7.1 in the textbook:
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
t = -10:0.01:10;

%Amplitudes of multi-path components
alpha = [0.7 0.5 0.2];
delay = [0 0.4 0.8];

%Compute sinc function
y1 = alpha(1)*sinc(t-delay(1));
y2 = alpha(2)*sinc(t-delay(2));
y3 = alpha(3)*sinc(t-delay(3));



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(t,y1,'-b','LineWidth',2);
plot(t,y2,'--r','LineWidth',2);
plot(t,y3,'-.k','LineWidth',2);
plot(t,y1+y2+y3,'k:*','LineWidth',2,'MarkerIndices',find(mod(t,1)==0));
ax = gca;   
set(ax, 'XTick', -5:8);
xticklabels({'$-\frac{5}{B}$','$-\frac{4}{B}$','$-\frac{3}{B}$','$-\frac{2}{B}$','$-\frac{1}{B}$','$0$','$\frac{1}{B}$','$\frac{2}{B}$','$\frac{3}{B}$','$\frac{4}{B}$','$\frac{5}{B}$','$\frac{6}{B}$','$\frac{7}{B}$','$\frac{8}{B}$'})
xlabel('Time $t$ [s]','Interpreter','latex');
ylabel('Signal','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$0.7\mathrm{sinc}(Bt)$','$0.5\mathrm{sinc}(Bt-0.4)$','$0.2\mathrm{sinc}(Bt-0.8)$','$(p*g*p)(t)$ and $h[k]$'},'Interpreter','latex');
xlim([-5 8]);
ylim([-0.5 1.5]);
