%This Matlab script can be used to reproduce Figure 6.10 in the textbook:
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


%Bandwidth in MHz
B = 10;


%% Generate rate region with different channel quality
set(groot,'defaultAxesTickLabelInterpreter','latex');

%Select SNR values
SNR1 = 10;
SNR2 = 5;
SNR3 = 2.5;


%Plot simulation results
figure;
hold on; box on; grid on;

plot3([B*log2(1+SNR1) B*log2(1+SNR1) B*log2(1+SNR1/(SNR2+1)) 0],[0 B*log2(1+SNR2/(SNR1+1)) B*log2(1+SNR2) B*log2(1+SNR2)],[0 0 0 0],'k:','LineWidth',2);
plot3([B*log2(1+SNR1) B*log2(1+SNR1) B*log2(1+SNR1/(SNR3+1)) 0],[0 0 0 0],[0 B*log2(1+SNR3/(SNR1+1)) B*log2(1+SNR3) B*log2(1+SNR3)],'k:','LineWidth',2);
plot3([0 0 0 0],[B*log2(1+SNR2) B*log2(1+SNR2) B*log2(1+SNR2/(SNR3+1)) 0],[0 B*log2(1+SNR3/(SNR2+1)) B*log2(1+SNR3) B*log2(1+SNR3)],'k:','LineWidth',2);
plot3([B*log2(1+SNR1/(1+SNR3)) B*log2(1+SNR1/(1+SNR3)) B*log2(1+SNR1/(SNR3+SNR2+1)) 0],[0 B*log2(1+SNR2/(SNR3+SNR1+1)) B*log2(1+SNR2/(SNR3+1)) B*log2(1+SNR2/(SNR3+1))],[B*log2(1+SNR3) B*log2(1+SNR3) B*log2(1+SNR3) B*log2(1+SNR3)],'k:','LineWidth',2);
plot3([B*log2(1+SNR1/(1+SNR2)) B*log2(1+SNR1/(1+SNR2)) B*log2(1+SNR1/(SNR2+SNR3+1)) 0],[B*log2(1+SNR2) B*log2(1+SNR2) B*log2(1+SNR2) B*log2(1+SNR2)],[0 B*log2(1+SNR3/(SNR1+SNR2+1)) B*log2(1+SNR3/(1+SNR2)) B*log2(1+SNR3/(1+SNR2))],'k:','LineWidth',2);
plot3([B*log2(1+SNR1) B*log2(1+SNR1) B*log2(1+SNR1) B*log2(1+SNR1)],[B*log2(1+SNR2/(SNR1+1)) B*log2(1+SNR2/(SNR1+1)) B*log2(1+SNR2/(SNR1+SNR3+1)) 0],[0 B*log2(1+SNR3/(SNR1+SNR2+1)) B*log2(1+SNR3/(SNR1+1)) B*log2(1+SNR3/(SNR1+1))],'k:','LineWidth',2);
plot3([B*log2(1+SNR1/(SNR2+SNR3+1)) B*log2(1+SNR1/(SNR2+SNR3+1))],[B*log2(1+SNR2/(SNR3+1)) B*log2(1+SNR2)],[B*log2(1+SNR3) B*log2(1+SNR3/(SNR2+1))],'k','LineWidth',2);
plot3([B*log2(1+SNR1/(SNR3+1)) B*log2(1+SNR1)],[B*log2(1+SNR2/(SNR1+SNR3+1)) B*log2(1+SNR2/(SNR1+SNR3+1))],[B*log2(1+SNR3) B*log2(1+SNR3/(SNR1+1))],'k','LineWidth',2);
plot3([B*log2(1+SNR1/(SNR2+1)) B*log2(1+SNR1)],[B*log2(1+SNR2) B*log2(1+SNR2/(SNR1+1))],[B*log2(1+SNR3/(SNR1+SNR2+1)) B*log2(1+SNR3/(SNR1+SNR2+1))],'k','LineWidth',2);
plot3([B*log2(1+SNR1/(1+SNR3)) B*log2(1+SNR1/(SNR3+SNR2+1))],[B*log2(1+SNR2/(SNR3+SNR1+1)) B*log2(1+SNR2/(SNR3+1))],[B*log2(1+SNR3) B*log2(1+SNR3)],'k','LineWidth',2);
plot3([B*log2(1+SNR1/(1+SNR2)) B*log2(1+SNR1/(SNR2+SNR3+1))],[B*log2(1+SNR2) B*log2(1+SNR2)],[B*log2(1+SNR3/(SNR1+SNR2+1)) B*log2(1+SNR3/(1+SNR2))],'k','LineWidth',2);
plot3([B*log2(1+SNR1) B*log2(1+SNR1)],[B*log2(1+SNR2/(SNR1+1)) B*log2(1+SNR2/(SNR1+SNR3+1))],[B*log2(1+SNR3/(SNR1+SNR2+1)) B*log2(1+SNR3/(SNR1+1))],'k','LineWidth',2);

view(142.5,30);

xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
zlabel('$R_3$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
xticks(0:10:40);
set(gcf, 'Renderer', 'Painters');
