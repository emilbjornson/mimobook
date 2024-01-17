%This Matlab script can be used to reproduce Figure 6.16 in the textbook:
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


%Select range of the number of antennas
Mvalues = [10 20];

%Select the angles-of-arrival for the different users
varphi = [-pi/16 -pi/32 0 pi/24];

%Extract the number of users
K = length(varphi);

%Select the range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);


%Prepare to save simulation results
sumrate_nonlinear = zeros(length(SNR),length(Mvalues));
sumrate_linear = zeros(length(SNR),length(Mvalues));
sumrate_orthogonal = zeros(length(SNR),length(Mvalues));


%% Generate rate region with different number of antennas

for m = 1:length(Mvalues)
    
    %Generate array responses with a ULA
    H = [exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(1))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(2))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(3))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(4))/2)];
    
    %Compute the sum rate with orthogonal access, which is a SIMO system
    %where the SNR is increased by a factor K since every user is only
    %assigned 1/K of the bandwidth
    sumrate_orthogonal(:,m) = log2(1+SNR*Mvalues(m)*K);
    
    %Comput the sum rates with non-linear and linear processing
    for s = 1:length(SNR)
    
        sumrate_nonlinear(s,m) = real(log2(det(eye(Mvalues(m))+SNR(s)*(H*H'))));
        
        for k = 1:K
            
            sumrate_linear(s,m) = sumrate_linear(s,m) + log2(1+SNR(s)*real(H(:,k)'*((SNR(s)*(H*H'-H(:,k)*H(:,k)')+eye(Mvalues(m)))\H(:,k))));
            
        end
    
    end
    
end


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,sumrate_nonlinear(:,1),'k','LineWidth',2);
plot(SNRdB,sumrate_linear(:,1),'b-.','LineWidth',2);
plot(SNRdB,sumrate_orthogonal(:,1),'r-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Sum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'Non-linear','Linear','OMA'},'Interpreter','latex','Location','NorthWest');
ylim([0 60]);


figure;
hold on; box on; grid on;
plot(SNRdB,sumrate_nonlinear(:,2),'k','LineWidth',2);
plot(SNRdB,sumrate_linear(:,2),'b-.','LineWidth',2);
plot(SNRdB,sumrate_orthogonal(:,2),'r-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Sum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'Non-linear','Linear','OMA'},'Interpreter','latex','Location','NorthWest');
ylim([0 60]);
