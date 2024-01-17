%This Matlab script can be used to reproduce Figure 2.12 in the textbook:
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

%Compute sinc function with different delays
y1 = sinc(t);
y2 = sinc(t-1);
y3 = sinc(t-2);

%Symbol values in PAM
x = [1 0.5 -0.5];


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(t,y1,'-b','LineWidth',2);
plot(t,y2,'--r','LineWidth',2);
plot(t,y3,'-.k','LineWidth',2);
ax = gca;
set(ax, 'XTick', -3:5);
xticklabels({'$-\frac{3}{B}$','$-\frac{2}{B}$','$-\frac{1}{B}$','$0$','$\frac{1}{B}$','$\frac{2}{B}$','$\frac{3}{B}$','$\frac{4}{B}$','$\frac{5}{B}$'})
set(ax, 'YTick', -0.5:0.5:1);
yticklabels({'$-\sqrt{B}/2$','$0$','$\sqrt{B}/2$','$\sqrt{B}$'})
xlabel('Time $t$ [s]','Interpreter','latex');
ylabel('Signal','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$p(t)$','$p(t-1/B)$','$p(t-2/B)$'},'Interpreter','latex');
xlim([-3 5]);
ylim([-0.5 1]);


figure;
hold on; box on; grid on;
plot(t,x(1)*y1+x(2)*y2+x(3)*y3,'k:','LineWidth',2);
plot(t,x(1)*y1,'-b','LineWidth',2);
plot(t,x(2)*y2,'--r','LineWidth',2);
plot(t,x(3)*y3,'-.k','LineWidth',2);
ax = gca;
set(ax, 'XTick', -3:5);
xticklabels({'$-\frac{3}{B}$','$-\frac{2}{B}$','$-\frac{1}{B}$','$0$','$\frac{1}{B}$','$\frac{2}{B}$','$\frac{3}{B}$','$\frac{4}{B}$','$\frac{5}{B}$'})
set(ax, 'YTick', -0.5:0.5:1.5);
yticklabels({'$-\sqrt{B}/2$','$0$','$\sqrt{B}/2$','$\sqrt{B}$','$3\sqrt{B}/2$'})
xlabel('Time $t$ [s]','Interpreter','latex');
ylabel('Signal','Interpreter','latex');
set(gca,'fontsize',16);
legend({'PAM signal $z(t)$','$1 \cdot p(t)$','$0.5 \cdot p(t-1/B)$','$-0.5 \cdot p(t-2/B)$'},'Interpreter','latex');
xlim([-3 5]);
ylim([-0.5 1.5]);

