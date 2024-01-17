%This Matlab script can be used to reproduce Figure 6.29 in the textbook:
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
sumrate_LMMSE = zeros(length(SNR),length(Mvalues));
sumrate_ZF = zeros(length(SNR),length(Mvalues));
sumrate_RZF = zeros(length(SNR),length(Mvalues));
sumrate_orthogonal = zeros(length(SNR),length(Mvalues));


%% Generate rate region with different number of antennas

for m = 1:length(Mvalues)

    %Generate array responses with a ULA
    H = [exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(1))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(2))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(3))/2) exp(-1i*2*pi*(0:Mvalues(m)-1)'*sin(varphi(4))/2)];

    %Compute the sum rate with orthogonal access, which results in serving
    %one user using K times more power
    sumrate_orthogonal(:,m) = log2(1+SNR*Mvalues(m)*K);



    %ZF matrix
    P_ZF = conj(H/(H'*H));
    P_ZF = P_ZF*diag(1./sqrt(sum(abs(P_ZF).^2,1)));


    %Comput the sum rates with non-linear and linear processing
    for s = 1:length(SNR)

        %Optimizing the power allocation for the non-linear case (this is a
        %convex problem)
        rate_DPC = @(x) real(log2(det(eye(Mvalues(m))+SNR(s)*(H*diag(x)*H'))));
        options = optimoptions('fmincon','Display','off');
        powerOpt = fmincon(@(x) -rate_DPC(x),ones(K,1),ones(1,K),K,[],[],zeros(K,1),[],[],options);
        sumrate_nonlinear(s,m) = rate_DPC(powerOpt);


        %Optimizing the power allocation through a grid search in the
        %virtual uplink
        powerVariation = linspace(0,1,51);

        rateVariations = zeros(length(powerVariation)^3,1);
        n = 0;
        for n1 = 1:length(powerVariation)
            for n2 = 1:length(powerVariation)
                for n3 = 1:length(powerVariation)
                    x = [4*powerVariation(n1)*powerVariation(n2); 4*powerVariation(n1)*(1-powerVariation(n2)); 4*(1-powerVariation(n1))*powerVariation(n3); 4*(1-powerVariation(n1))*(1-powerVariation(n3))];
                    n = n+1;
                        for k = 1:K
                            rateVariations(n) = rateVariations(n) + log2(1+x(k)*SNR(s)*real(H(:,k)'*((SNR(s)*(H*diag(x)*H'-x(k)*H(:,k)*H(:,k)')+eye(Mvalues(m)))\H(:,k))));
                        end

                end
            end
        end

        sumrate_LMMSE(s,m) = max(rateVariations);


        %Compute the sum rate with ZF and equal power allocation

        A = abs(H.'*P_ZF).^2;

        sumrate_ZF(s,m) = sum(log2(1+diag(A)./(sum(A,2)-diag(A)+ones(K,1)/SNR(s))));


        %Compute the sum rate with RZF and equal power allocation
        P_RZF = conj(H/(H'*H+eye(K)/SNR(s)));
        P_RZF = P_RZF*diag(1./sqrt(sum(abs(P_RZF).^2,1)));

        A = abs(H.'*P_RZF).^2;

        sumrate_RZF(s,m) = sum(log2(1+diag(A)./(sum(A,2)-diag(A)+ones(K,1)/SNR(s))));


    end

end


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,sumrate_nonlinear(:,1),'k','LineWidth',2);
plot(SNRdB,sumrate_LMMSE(:,1),'b-.','LineWidth',2);
plot(SNRdB,sumrate_RZF(:,1),'r-','LineWidth',2);
plot(SNRdB,sumrate_ZF(:,1),'k:','LineWidth',2);
plot(SNRdB,sumrate_orthogonal(:,1),'g--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Sum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'Non-linear','LMMSE','RZF','ZF','OMA'},'Interpreter','latex','Location','NorthWest');
ylim([0 60]);


figure;
hold on; box on; grid on;
plot(SNRdB,sumrate_nonlinear(:,2),'k','LineWidth',2);
plot(SNRdB,sumrate_LMMSE(:,2),'b-.','LineWidth',2);
plot(SNRdB,sumrate_RZF(:,2),'r-','LineWidth',2);
plot(SNRdB,sumrate_ZF(:,2),'k:','LineWidth',2);
plot(SNRdB,sumrate_orthogonal(:,2),'g--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Sum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'Non-linear','LMMSE','RZF','ZF','OMA'},'Interpreter','latex','Location','NorthWest');
ylim([0 60]);
