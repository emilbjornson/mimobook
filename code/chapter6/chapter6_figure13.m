%This Matlab script can be used to reproduce Figure 6.13 in the textbook:
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

%Select range of the number of antennas
Mvalues = [1 2 4 8];

%Select angles-of-arrival for the two users
varphi1 = -pi/20;
varphi2 = pi/20;

%Select SNRs of the two users (for M=1 antenna)
SNR1 = 10;
SNR2 = 5;


%% Generate rate region with different number of antennas

rate1_nonlinear = zeros(4,length(Mvalues));
rate2_nonlinear = zeros(4,length(Mvalues));

for m = 1:length(Mvalues)
    
    %Generate array responses with a ULA
    h1 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi1));
    h2 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi2));
    
    %Compute points on the Pareto boundary of the rate region
    rate1_nonlinear(:,m) = [B*log2(1+SNR1*norm(h1)^2) B*log2(1+SNR1*norm(h1)^2) B*log2(1+SNR1*real(h1'*((SNR2*(h2*h2')+eye(Mvalues(m)))\h1))) 0]';
    rate2_nonlinear(:,m) = [0 B*log2(1+SNR2*real(h2'*((SNR1*(h1*h1')+eye(Mvalues(m)))\h2))) B*log2(1+SNR2*norm(h2)^2) B*log2(1+SNR2*norm(h2)^2)]';
    
end


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(rate1_nonlinear(:,4),rate2_nonlinear(:,4),'k','LineWidth',2);
plot(rate1_nonlinear(:,3),rate2_nonlinear(:,3),'b--','LineWidth',2);
plot(rate1_nonlinear(:,2),rate2_nonlinear(:,2),'k:','LineWidth',2);
plot(rate1_nonlinear(:,1),rate2_nonlinear(:,1),'r-.','LineWidth',2);

xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 70 0 70]);
xticks(0:10:70);
legend({'$M=8$','$M=4$','$M=2$','$M=1$'},'Interpreter','latex','Location','SouthWest');
axis square