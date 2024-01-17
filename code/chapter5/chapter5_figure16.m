%This Matlab script can be used to reproduce Figure 5.16 in the textbook:
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


%Number of antennas in the SIMO and MISO channels
Mvalues = [1 2];

%Rate requirement: 1 bit/symbol
R = 1;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Prepare to save simulation results
Pout_MISO = zeros(length(SNR),1);
Pout_SIMO = zeros(length(SNR),length(Mvalues));


%% Go through all number of antennas
for k = 1:length(Mvalues)

    %Extract number of antennas
    M = Mvalues(k);


    for n = 1:length(SNR)

        %Compute outage probability with receive diversity

        Pout_SIMO(n,k) = 1;

        for m = 0:M-1
            Pout_SIMO(n,k) = Pout_SIMO(n,k) - exp(-(2^R-1)/SNR(n)) * ((2^R-1)/SNR(n))^m / factorial(m);
        end


        %Compute outage probability with transmit diversity
        if M == 2

            Pout_MISO(n) = 1;

            for m = 0:M-1
                Pout_MISO(n) = Pout_MISO(n) - exp(-2*(2^R-1)/SNR(n)) * (2*(2^R-1)/SNR(n))^m / factorial(m);
            end

        end

    end

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,Pout_SIMO(:,1),'k','LineWidth',2);
plot(SNRdB,Pout_MISO(:,1),'r--','LineWidth',2);
plot(SNRdB,Pout_SIMO(:,2),'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('$P_{\textrm{out}}$','Interpreter','latex');
set(gca,'Yscale','log');
ylim([1e-4 1]);
legend({'SISO: $M=1$','MISO: $M=2$','SIMO: $M=2$'},'Interpreter','latex')
set(gca,'fontsize',16);
