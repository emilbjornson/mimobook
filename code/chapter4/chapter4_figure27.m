%This Matlab script can be used to reproduce Figure 4.27 in the textbook:
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


%Number of transmit antennas
K = 4;

%Number of receive antennas
M = 4;

%Wavelength
lambda = 0.1;

%Antenna spacing
Delta = 0.5*lambda;

%Compute locations of transmit antennas in a ULA
transmitAntennas = 1i*(-(K-1)/2:(K-1)/2)*Delta;


%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);



%Distance to the receiver
d = 200;


%Select the vartheta angles for the antenna separation, where 0 refers to
%having a ULA at the receiver
varthetaAngles = [0 20 75];


%Prepare to compute the channel capacity
capacity = zeros(length(SNR),length(varthetaAngles));



for ind = 1:length(varthetaAngles)
    
    %Compute the receive antenna locations
    if varthetaAngles(ind)==0
        
        receiveAntennas = d + 1i*(-(M-1)/2:(M-1)/2)'*Delta;
        
    else
        
        receiveAntennas = d*exp(1i*pi*linspace(-varthetaAngles(ind)/2,varthetaAngles(ind)/2,M)'/180);
        
    end
    
    %Compute the distance between all pairs of transmit and receive antennas
    distances = abs(repmat(transmitAntennas,[M 1]) - repmat(receiveAntennas,[1 K]));
    
    %Compute the channel matrix
    H = exp(-1i*2*pi*distances/lambda);
    
    %Compute the singular values
    s = svd(H);
    
    
    %Perform water-filling power allocation for each SNR value
    for n = 1:length(SNR)
        
        powerAllocation = functionWaterfilling(SNR(n),1./s.^2);
        
        capacity(n,ind) = sum(log2(1+powerAllocation.*s.^2));
                
    end
    
end



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,4*log2(1+SNR),'k:','LineWidth',2);
plot(SNRdB,capacity(:,3),'k','LineWidth',2);
plot(SNRdB,capacity(:,2),'r--','LineWidth',2);
plot(SNRdB,capacity(:,1),'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'Reference','Distributed: $\vartheta = 75^\circ$','Distributed: $\vartheta = 20^\circ$','ULA'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);


