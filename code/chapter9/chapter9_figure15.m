%This Matlab script can be used to reproduce Figure 9.15 in the textbook:
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

%Define the individual channel gains
beta_t = db2pow(-80);
beta_r = db2pow(-60);
beta_s = db2pow(-110);


%Number of atoms
N = 200;

%Define the SNR for the static path
SNRrangedB = (-20:1:20)';

%Compute the range of transmit SNRs
PBN0 = db2pow(SNRrangedB)/beta_s;


%Compute the end-to-end channel gain for the two cases
channelgain_perfect = (sqrt(beta_s)+N*sqrt(beta_t*beta_r)).^2;



%Number of random realizations for channel estimation
nbrOfRealizations = 5000;

%Prepare to store random end-to-end channel gain results
channelgain_imperfect = zeros(length(PBN0),nbrOfRealizations);
channelgain_random = zeros(length(PBN0),nbrOfRealizations);

%True channel vector has no phase-shifts, without loss of generality
h_check = [sqrt(beta_s); sqrt(beta_t*beta_r)*ones(N,1)];

for j = 1:length(PBN0)

    for n = 1:nbrOfRealizations

        %Compute ML estimate
        h_est = h_check + (randn(N+1,1)+1i*randn(N+1,1))/sqrt(2*(N+1)*PBN0(j));

        %Compute phase shifts as if the estimate is perfect
        phaseShifts = exp(1i*angle(h_est(1)))*conj(h_est)./abs(h_est);

        %Compute the end-to-end channel gain with the estimated phase shifts
        channelgain_imperfect(j,n) = abs(h_check'*phaseShifts).^2;

        %Generate random phase shifts
        phaseShifts_random = [1; exp(1i*2*pi*rand(N,1))];

        %Compute the end-to-end channel gain with random phase shifts
        channelgain_random(j,n) = abs(h_check'*phaseShifts_random).^2;

    end

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

plot(SNRrangedB,log2(1+PBN0*channelgain_perfect),'r-','LineWidth',2);
plot(SNRrangedB,mean(log2(1+PBN0.*channelgain_imperfect),2),'b-.','LineWidth',2);
plot(SNRrangedB,mean(log2(1+PBN0.*channelgain_random),2),'k--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'Perfect CSI','Imperfect CSI','Random'},'Interpreter','latex','Location','NorthWest','Location','NorthWest');
set(gca,'fontsize',16);
ylim([0 12]);
