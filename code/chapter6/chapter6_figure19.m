%This Matlab script can be used to reproduce Figure 6.19 in the textbook:
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
maxminrate_LMMSE = zeros(length(Mall),2);
maxminrate_MRC = zeros(length(Mall),2);
rate_LMMSE = zeros(K,length(Mall),iterationNumber+1);
SINR_LMMSE = zeros(K,length(Mall),iterationNumber+1);
rate_MRC = zeros(K,length(Mall),iterationNumber+1);
SINR_MRC = zeros(K,length(Mall),iterationNumber+1);
%% Go through different number of antennas

for m = 1:length(Mall)
    M = Mall(m);
    %Generate array responses with a ULA
    H = [exp(-1i*2*pi*(0:M-1)'*sin(varphi(1))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(2))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(3))/2) exp(-1i*2*pi*(0:M-1)'*sin(varphi(4))/2)  ];


   
    
    powerCoefNorm = ones(K,1);
    for k = 1:K
       
       SINR_LMMSE(k,m,1) = SNR*powerCoefNorm(k)*real(H(:,k)'*((SNR*(H*diag(powerCoefNorm)*H'-powerCoefNorm(k)*H(:,k)*H(:,k)')+eye(M))\H(:,k)));
       rate_LMMSE(k,m,1) = log2(1+ SINR_LMMSE(k,m,1));
        
    end
    maxminrate_LMMSE(m,2) = min(rate_LMMSE(:,m,1));

    %Fixed-point-algorithm
    for iterr = 1:iterationNumber
        powerCoefNorm = min(SINR_LMMSE(:,m,iterr))*powerCoefNorm./SINR_LMMSE(:,m,iterr);
        powerCoefNorm = powerCoefNorm/max(powerCoefNorm);
        for k = 1:K
       
            SINR_LMMSE(k,m,iterr+1) = SNR*powerCoefNorm(k)*real(H(:,k)'*((SNR*(H*diag(powerCoefNorm)*H'-powerCoefNorm(k)*H(:,k)*H(:,k)')+eye(M))\H(:,k)));
            rate_LMMSE(k,m,iterr+1) = log2(1+ SINR_LMMSE(k,m,iterr+1));

        end        
    end

    maxminrate_LMMSE(m,1) = min(rate_LMMSE(:,m,iterr+1));

     
    %MRC matrix
    W_MRC = H;


    powerCoefNorm = ones(K,1);
    for k = 1:K
       
       SINR_MRC(k,m,1) = SNR*powerCoefNorm(k)*abs(H(:,k)'*W_MRC(:,k))^2/real(W_MRC(:,k)'*(SNR*(H*diag(powerCoefNorm)*H'-powerCoefNorm(k)*H(:,k)*H(:,k)')+eye(M))*W_MRC(:,k));
       rate_MRC(k,m,1) = log2(1+ SINR_MRC(k,m,1));
        
    end
    maxminrate_MRC(m,2) = min(rate_MRC(:,m,1));

    %Fixed-point-algorithm
    for iterr = 1:iterationNumber
        powerCoefNorm = min(SINR_MRC(:,m,iterr))*powerCoefNorm./SINR_MRC(:,m,iterr);
        powerCoefNorm = powerCoefNorm/max(powerCoefNorm);
        for k = 1:K
       
            SINR_MRC(k,m,iterr+1) = SNR*powerCoefNorm(k)*abs(H(:,k)'*W_MRC(:,k))^2/real(W_MRC(:,k)'*(SNR*(H*diag(powerCoefNorm)*H'-powerCoefNorm(k)*H(:,k)*H(:,k)')+eye(M))*W_MRC(:,k));
            rate_MRC(k,m,iterr+1) = log2(1+ SINR_MRC(k,m,iterr+1));

        end        
    end

    maxminrate_MRC(m,1) = min(rate_MRC(:,m,iterr+1));
    
    
end
rate_LMMSE = rate_LMMSE(:,3,:);

%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(1:8,rate_LMMSE(1,1:8),'b-','LineWidth',2);
plot(1:8,rate_LMMSE(2,1:8),'k--','LineWidth',2);
plot(1:8,rate_LMMSE(3,1:8),'r-.','LineWidth',2);
plot(1:8,rate_LMMSE(4,1:8),'k:','LineWidth',2);
xlabel('Iteration','Interpreter','latex');
ylabel('Rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'User 1','User 2','User 3','User 4'},'Interpreter','latex','Location','NorthEast');
ylim([0 4]);
xlim([1 8]);

figure;
hold on; box on; grid on;
plot(Mall,maxminrate_LMMSE(:,1),'b-','LineWidth',2);
plot(Mall,maxminrate_LMMSE(:,2),'k--','LineWidth',2);
plot(Mall,maxminrate_MRC(:,1),'r-.','LineWidth',2);
plot(Mall,maxminrate_MRC(:,2),'k:','LineWidth',2);
xlabel('Number of antennas $(M)$','Interpreter','latex');
ylabel('Minimum rate [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'LMMSE: max-min','LMMSE: full','MRC: max-min','MRC: full'},'Interpreter','latex','Location','NorthWest');
ylim([0 7.2]);
