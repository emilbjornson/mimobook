%This Matlab script can be used to reproduce Figure 9.21 in the textbook:
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

%Number of antennas
M = [2 4 8];
K = [2 4 8];

%Number of atoms
N = 100;

%Set SNR value
SNRdB = 0;
SNR = db2pow(SNRdB);

%Determine how much weaker the cascaded path is compared to the static
weakerPath = 1/10;

%Set the number of iterations in algorithm
L = 5;

%Set k-factor
kappa = 10;

%Number of random channel realizations
nbrOfrealizations = 500;


%Prepare to compute the channel capacity
capacity_MIMO = zeros(L+1,nbrOfrealizations,length(M));

capacity_SISO = zeros(nbrOfrealizations,1);

for m = 1:length(M)

    %Go through different random channel realizations
    for ind = 1:nbrOfrealizations

        %Generate an iid Rayleigh fading channel realization for static channel
        Hs = (randn(M(m),K(m))+1i*randn(M(m),K(m)))/sqrt(2);

        %Generate Rician fading channels to and from the surface
        Hr = sqrt(weakerPath)*(sqrt(kappa/(kappa+1))*exp(1i*2*pi*rand(1,1))*ones(M(m),N)+sqrt(1/(kappa+1))*(randn(M(m),N)+1i*randn(M(m),N))/sqrt(2));
        Ht = sqrt(kappa/(kappa+1))*exp(1i*2*pi*rand(1,1))*ones(N,K(m))+sqrt(1/(kappa+1))*(randn(N,K(m))+1i*randn(N,K(m)))/sqrt(2);

        %Initalize phase-shift vector
        psiVec = exp(1i*2*pi*rand(N,1)); 

        %Go through iterations of the algorithm
        for l = 1:L

            %Compute the channel with the current configuration
            H = Hs + Hr*diag(psiVec)*Ht;

            %Compute the singular values
            [~,S,V] = svd(H);
            s = diag(S);

            %Perform water-filling power allocation
            powerAllocation = functionWaterfilling(SNR,1./s.^2);

            %Compute and store the capacity
            capacity_MIMO(l,ind,m) = sum(log2(1+powerAllocation.*s.^2));

            %Store the capacity-achieving covariance matrix
            signalCov = V*diag(powerAllocation)*V';

            %Refine the phase-shift of one atom at a time
            for n = 1:N

                %Compute the matrices/vectors in the algorithm
                Hn = Hs + Hr*diag(psiVec)*Ht - psiVec(n)*Hr(:,n)*Ht(n,:);
                bn = Hn*signalCov*Ht(n,:)';
                An = eye(M(m)) + Hn*signalCov*Hn' + Hr(:,n)*Ht(n,:)*signalCov*(Hr(:,n)*Ht(n,:))';

                %Update the phase-shift
                psiVec(n) = exp(-1i*angle(bn'*(An\Hr(:,n))));

            end


        end

        %Compute the final capacity, when the algorithm has terminated
        H = Hs + Hr*diag(psiVec)*Ht;
        [U,S,V] = svd(H);
        s = diag(S);

        powerAllocation = functionWaterfilling(SNR,1./s.^2);

        capacity_MIMO(L+1,ind,m) = sum(log2(1+powerAllocation.*s.^2));

    end

end




%Go through different random channel realizations for the SISO case
for ind = 1:nbrOfrealizations

    %Generate an iid Rayleigh fading channel realization for static channel
    hs = (randn(1,1)+1i*randn(1,1))/sqrt(2);

    %Generate Rician fading channels to and from the surface
    hr = sqrt(weakerPath)*(sqrt(kappa/(kappa+1))*exp(1i*2*pi*rand(1,1))*ones(1,N)+sqrt(1/(kappa+1))*(randn(1,N)+1i*randn(1,N))/sqrt(2));
    ht = sqrt(kappa/(kappa+1))*exp(1i*2*pi*rand(1,1))*ones(N,1)+sqrt(1/(kappa+1))*(randn(N,1)+1i*randn(N,1))/sqrt(2);

    capacity_SISO(ind) = log2(1+SNR*(abs(hs)+abs(hr)*abs(ht))^2);

end



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(0:L,mean(capacity_MIMO(:,:,3),2),'r*-','LineWidth',2);
plot(0:L,mean(capacity_MIMO(:,:,2),2),'ks--','LineWidth',2);
plot(0:L,mean(capacity_MIMO(:,:,1),2),'bd-.','LineWidth',2);
plot(0:L,mean(capacity_SISO)*ones(1,L+1),'k:','LineWidth',2);
xlabel('Iteration','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'$M=K=8$','$M=K=4$','$M=K=2$','$M=K=1$'},'Interpreter','latex','Location','SouthEast');
set(gca,'fontsize',16);
ylim([0 25]);
