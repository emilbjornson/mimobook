%This Matlab script can be used to reproduce Figure 6.30 in the textbook:
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

%Select the range of SNR values
SNRdB = 10;
SNR = db2pow(SNRdB);

%Select range of the number of antennas
Mall = 4:1:16;

%Select the angles-of-arrival for the different users
varphi = [-pi/16 -pi/32 0 pi/24];

%Extract the number of users
K = length(varphi);


iterationNumber = 50;


%Prepare to save simulation results
maxminrate_RZF = zeros(length(Mall),2);
maxminrate_MRT = zeros(length(Mall),2);
rate_RZF = zeros(K,length(Mall),iterationNumber+1);
SINR_RZF = zeros(K,length(Mall),iterationNumber+1);
rate_MRT = zeros(K,length(Mall),iterationNumber+1);
SINR_MRT = zeros(K,length(Mall),iterationNumber+1);

for m = 1:length(Mall)
    M = Mall(m);
    %Generate array responses with a ULA
    H = [exp(-1i*2*pi*(0:M-1)'*sin(varphi(1))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(2))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(3))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(4))/2)  ];


   
    
    powerCoefNorm = ones(K,1);
    P_RZF = conj(H)/(SNR*H.'*conj(H)+eye(K));
    P_RZF = P_RZF*diag(1./vecnorm(P_RZF));
    innerProd_RZF = H.'*P_RZF;
    for k = 1:K
       
       SINR_RZF(k,m,1) = SNR*powerCoefNorm(k)*abs(innerProd_RZF(k,k))^2/(SNR*abs(innerProd_RZF(k,:)).^2*powerCoefNorm-SNR*powerCoefNorm(k)*abs(innerProd_RZF(k,k))^2+1);
       rate_RZF(k,m,1) = log2(1+ SINR_RZF(k,m,1));
        
    end
    maxminrate_RZF(m,2) = min(rate_RZF(:,m,1));

    %Fixed-point-algorithm
    for iterr = 1:iterationNumber
        powerCoefNorm = min(SINR_RZF(:,m,iterr))*powerCoefNorm./SINR_RZF(:,m,iterr);
        powerCoefNorm = K*powerCoefNorm/sum(powerCoefNorm);
        for k = 1:K
       
            SINR_RZF(k,m,iterr+1) = SNR*powerCoefNorm(k)*abs(innerProd_RZF(k,k))^2/(SNR*abs(innerProd_RZF(k,:)).^2*powerCoefNorm-SNR*powerCoefNorm(k)*abs(innerProd_RZF(k,k))^2+1);
            rate_RZF(k,m,iterr+1) = log2(1+ SINR_RZF(k,m,iterr+1));

        end        
    end

    maxminrate_RZF(m,1) = min(rate_RZF(:,m,iterr+1));

     
    %MRT matrix
    P_MRT = conj(H);
    P_MRT = P_MRT*diag(1./vecnorm(P_MRT));

    innerProd_MRT = H.'*P_MRT;
    powerCoefNorm = ones(K,1);
    for k = 1:K
       
       SINR_MRT(k,m,1) = SNR*powerCoefNorm(k)*abs(innerProd_MRT(k,k))^2/(SNR*abs(innerProd_MRT(k,:)).^2*powerCoefNorm-SNR*powerCoefNorm(k)*abs(innerProd_MRT(k,k))^2+1);
       rate_MRT(k,m,1) = log2(1+ SINR_MRT(k,m,1));
        
    end
    maxminrate_MRT(m,2) = min(rate_MRT(:,m,1));

    %Fixed-point-algorithm
    for iterr = 1:iterationNumber
        powerCoefNorm = min(SINR_MRT(:,m,iterr))*powerCoefNorm./SINR_MRT(:,m,iterr);
        powerCoefNorm = K*powerCoefNorm/sum(powerCoefNorm);
        for k = 1:K
       
            SINR_MRT(k,m,iterr+1) = SNR*powerCoefNorm(k)*abs(innerProd_MRT(k,k))^2/(SNR*abs(innerProd_MRT(k,:)).^2*powerCoefNorm-SNR*powerCoefNorm(k)*abs(innerProd_MRT(k,k))^2+1);
            rate_MRT(k,m,iterr+1) = log2(1+ SINR_MRT(k,m,iterr+1));

        end        
    end

    maxminrate_MRT(m,1) = min(rate_MRT(:,m,iterr+1));
    
    
end
rate_RZF = rate_RZF(:,3,:);

%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(1:8,rate_RZF(1,1:8),'b-','LineWidth',2);
plot(1:8,rate_RZF(2,1:8),'k--','LineWidth',2);
plot(1:8,rate_RZF(3,1:8),'r-.','LineWidth',2);
plot(1:8,rate_RZF(4,1:8),'k:','LineWidth',2);
xlabel('Iteration','Interpreter','latex');
ylabel('Rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'User 1','User 2','User 3','User 4'},'Interpreter','latex','Location','NorthEast');
ylim([0 4]);
xlim([1 8]);

figure;
hold on; box on; grid on;
plot(Mall,maxminrate_RZF(:,1),'b-','LineWidth',2);
plot(Mall,maxminrate_RZF(:,2),'k--','LineWidth',2);
plot(Mall,maxminrate_MRT(:,1),'r-.','LineWidth',2);
plot(Mall,maxminrate_MRT(:,2),'k:','LineWidth',2);
xlabel('Number of antennas $(M)$','Interpreter','latex');
ylabel('Minimum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'RZF: max-min','RZF: equal','MRT: max-min','MRT: equal'},'Interpreter','latex','Location','NorthWest');
ylim([0 7.2]);
