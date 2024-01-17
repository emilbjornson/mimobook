%This Matlab script can be used to reproduce Figure 8.24 in the textbook:
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

clear
close all

%Number of antennas
MAll  = [1 10 10];

%Number of samples
LAll = [10 10 100];

%Set the SNR range
SNRAll = -40:1:20;

%Select the false alarm probability
PFA = 10.^(-3);

%Prepare to save simulation results
Pd = zeros(length(MAll),length(SNRAll));

%Select the number of random realizations
numberOfsetups = 100000;

%Compute the threshold for different number of samples
thAll = zeros(1,3);

for m = 1:length(LAll)
    thAll(m) = gammaincinv(1-PFA,LAll(m));
end


%Go through all SNRs and number of antennas
for s = 1:length(SNRAll)
    for m = 1:length(MAll)

        M = MAll(m); %Extract number of antennas
        L = LAll(m); %Extract number of samples
        threshold = thAll(m); %Extract the threshold
        rho = db2pow(SNRAll(s)); %Extract the SNR

        %Generate random noise realizations
        noiseRealizations = sqrt(0.5)*(randn(L,numberOfsetups)+1i*randn(L,numberOfsetups));

        %Generate RCS realizations
        RCSRealizations =  sqrt(0.5)*(randn(L,numberOfsetups)+1i*randn(L,numberOfsetups));

        %Compute received signal
        receivedSignal = sqrt(rho)*M*RCSRealizations+noiseRealizations;

        %Compute the detection probability numerically
        Pd(m,s) = length(find(sum(abs(receivedSignal).^2,1)>=threshold))/numberOfsetups;

    end
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRAll,Pd(1,:),'k','LineWidth',2)
plot(SNRAll,Pd(2,:),'r--','LineWidth',2)
plot(SNRAll,Pd(3,:),'b-.','LineWidth',2)
xlim([-40 20])

ax = gca;
xlabel('SNR [dB] ','Interpreter','latex');
ylabel('$P_{\rm D}$','Interpreter','latex');
legend({'$M=1$, $L=10$', '$M=10$, $L=10$', '$M=10$, $L=100$'},'Interpreter','latex','Location','SouthEast');
set(gca,'fontsize',16);



