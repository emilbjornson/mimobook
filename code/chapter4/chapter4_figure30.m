%This Matlab script can be used to reproduce Figure 4.30 in the textbook:
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


%Wavelength
lambda = 0.01;

%Antenna spacing
Delta = lambda;

%Number of antennas
M = 100;
K = M;


%Compute locations of transmit antennas in a ULA
transmitAntennas = 1i*(-(K-1)/2:(K-1)/2)*Delta;


%Set the SNR
SNRdB = 20;
SNR = db2pow(SNRdB);


%Near-field distances
d2 = 2*(M*Delta)^2/(lambda);
d3 = 2*(M*Delta)^2/(0.886*lambda);


%Distance to the receiver
d = [1:500 d2 d3];


%Prepare to compute the channel capacity
capacity = zeros(length(d),1);


%Go through the different wavelengths
for ind = 1:length(d)

    %Compute locations of receive antennas in a ULA
    receiveAntennas = d(ind) + 1i*(-(M-1)/2:(M-1)/2)'*Delta;

    %Compute the distance between all pairs of transmit and receive antennas
    distances = abs(repmat(transmitAntennas,[M 1]) - repmat(receiveAntennas,[1 K]));

    %Compute the channel matrix
    H = exp(-1i*2*pi*distances/lambda);

    %Compute the singular values
    s = svd(H);

    %Perform water-filling power allocation
    powerAllocation = functionWaterfilling(SNR,1./s.^2);

    %Compute the capacity
    capacity(ind) = sum(log2(1+powerAllocation.*s.^2));

end




%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(d(1:end-2),capacity(1:end-2,1),'b-.','LineWidth',2);
plot(d,ones(size(d))*log2(1+M*K*SNR(1)),'k:','LineWidth',2);
plot(d(end-1),capacity(end-1,1)','b*','LineWidth',2);
plot(d(end),capacity(end,1)','bs','LineWidth',2);
xlabel('Distance [m]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'Capacity','Reference (Rank 1)'},'Interpreter','latex','Location','NorthEast');
set(gca,'fontsize',16);
ylim([0 100]);



