%This Matlab script can be used to reproduce Figure 3.13 in the textbook:
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


%Select the s_k^2/N_0 for the two parallel channels
s1sqN0 = 1;
s2sqN0 = 1/4;

%Select the range of mu values
muValues = s1sqN0:0.01:10;


%Assign power according to water-filling
q1 = muValues-1/s1sqN0;
q2 = muValues-1/s2sqN0;
q2(q2<0) = 0;

%Compute the total symbol power for different mu values
q = q1+q2;

%Compute the rates achieved on the two channels
r1 = log2(1+q1*1);
r2 = log2(1+q2/4);



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(q,r1,'b-','LineWidth',2);
plot(q,r2,'r--','LineWidth',2);
xlabel('Normalized symbol power ($q$)','Interpreter','latex');
ylabel('Rate [bit/symbol]','Interpreter','latex');
legend({'Channel 1','Channel 2'},'Interpreter','latex','Location','NorthWest');
xticks(0:3:15);
set(gca,'fontsize',16);
