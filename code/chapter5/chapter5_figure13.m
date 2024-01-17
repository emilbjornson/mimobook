%This Matlab script can be used to reproduce Figure 5.13 in the textbook:
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

%Number of antennas in the SIMO channel
Mvalues = [1 2 4];

%Rate requirement: 1 bit/symbol
R = 1;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Prepare to save simulation results
Pout_MRC_exact = zeros(length(SNR),length(Mvalues));


%% Go through all number of antennas
for k = 1:length(Mvalues)

    %Extract number of antennas
    M = Mvalues(k);

    %Go through all SNR values
    for n = 1:length(SNR)

        %Compute the exact outage probability
        Pout_MRC_exact(n,k) = 1;

        for m = 0:M-1
            
            Pout_MRC_exact(n,k) = Pout_MRC_exact(n,k) - exp(-(2^R-1)/SNR(n)) * ((2^R-1)/SNR(n))^m / factorial(m);

        end

    end

end


upperBound = ((2^R-1)./SNR).^(Mvalues(2)) / factorial(Mvalues(2));


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,Pout_MRC_exact(:,1),'k','LineWidth',2);
plot(SNRdB,Pout_MRC_exact(:,2),'r--','LineWidth',2);
plot(SNRdB,Pout_MRC_exact(:,3),'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('$P_{\textrm{out}}$','Interpreter','latex');
set(gca,'Yscale','log');
xlim([-10 30]);
ylim([1e-4 1]);
legend({'$M=1$','$M=2$','$M=4$'},'Interpreter','latex')
set(gca,'fontsize',16);



%% Plot simulation results
figure;
hold on; box on; grid on;
plot(SNRdB,upperBound,'k-.','LineWidth',2);
plot(SNRdB,Pout_MRC_exact(:,2),'r--','LineWidth',2);
plot(10*log10((2^R-1)/Mvalues(2)) * ones(2,1), [1e-5; 1],'k:','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('$P_{\textrm{out}}$','Interpreter','latex');
set(gca,'Yscale','log');
xlim([-10 30]);
yticks(10.^(-5:1:0));
ylim([0.99e-5 1]);
legend({'Upper bound','Exact'},'Interpreter','latex')
set(gca,'fontsize',16);


