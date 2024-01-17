%This Matlab script can be used to reproduce Figure 9.22 in the textbook:
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


%Select the number of receive antennas
M = 10;

%Select the angles-of-arrivals for the different users
varphi = [-pi/16 -pi/32 0 pi/24];

%Extract the number of users
K = length(varphi);

%Set SNR value
SNRdB = 0;
SNR = db2pow(SNRdB);

%Determine how much weaker the cascaded path is compared to the static
weakerPath = 1/100;

%Set the number of iterations in algorithm
L = 5;

%Set k-factor
kappa = 10;

%Set the range of number of atoms
N = 0:200;

%Number of random channel realizations
nbrOfrealizations = 500;


%Prepare to save simulation results
sumcapacity_L5 = zeros(length(N),nbrOfrealizations);
sumcapacity_L1 = zeros(length(N),nbrOfrealizations);
sumcapacity_random = zeros(length(N),nbrOfrealizations);


%Go through all random channel realizations
for itr = 1:nbrOfrealizations

    %Generate array responses with a ULA for the static path
    Hs = exp(1i*2*pi*(0:M-1)'*sin(varphi)/2);


    %Go through the range of number of atoms
    for k = 1:length(N)

        if k == 1 %If there is no surface

            H = Hs;
            H1 = Hs;
            H_random = Hs;

        else

            %Generate Rician fading channel from the surface
            Hr = sqrt(weakerPath)*(sqrt(kappa/(kappa+1))*exp(1i*2*pi*rand(1,1))*ones(M,N(k))+sqrt(1/(kappa+1))*(randn(M,N(k))+1i*randn(M,N(k)))/sqrt(2));

            %Generate Rayleigh fading user channels to the surface
            Ht = (randn(N(k),K)+1i*randn(N(k),K))/sqrt(2);

            %Initalize phase-shift vector
            psiVec = exp(1i*2*pi*rand(N(k),1));

            %Save the channel with the initial configuration
            H_random = Hs + Hr*diag(psiVec)*Ht;

            %Go through iterations of the algorithm
            for l = 1:L

                %Refine the phase-shift of one atom at a time
                for n = 1:N(k)

                    %Compute the matrices/vectors in the algorithm
                    Hn = Hs + Hr*diag(psiVec)*Ht - psiVec(n)*Hr(:,n)*Ht(n,:);
                    bn = SNR*Hn*Ht(n,:)';
                    An = eye(M) + SNR*(Hn*Hn') + SNR*Hr(:,n)*Ht(n,:)*(Hr(:,n)*Ht(n,:))';

                    %Update the phase-shift
                    psiVec(n) = exp(-1i*angle(bn'*(An\Hr(:,n))));

                end

                if l == 1

                    %Save the channel after one iteration
                    H1 = Hs + Hr*diag(psiVec)*Ht;

                end

            end

            %Compute the resulting channel matrix
            H = Hs + Hr*diag(psiVec)*Ht;

            
        end

        %Compute the sum capacity after the algorithm finishes
        sumcapacity_L5(k,itr) = real(log2(det(eye(M)+SNR*(H*H'))));

        %Compute the sum capacity after one iteration
        sumcapacity_L1(k,itr) = real(log2(det(eye(M)+SNR*(H1*H1'))));

        %Compute the sum capacity with random initialization 
        sumcapacity_random(k,itr) = real(log2(det(eye(M)+SNR*(H_random*H_random'))));

    end

end


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(N,mean(sumcapacity_L5,2),'r','LineWidth',2);
plot(N,mean(sumcapacity_L1,2),'k--','LineWidth',2);
plot(N,mean(sumcapacity_random,2),'b-.','LineWidth',2);
xlabel('Number of atoms ($N$)','Interpreter','latex');
ylabel('Sum capacity [bit/symbol]','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$L=5$ iterations','$L=1$ iteration','Random'},'Interpreter','latex','Location','SouthEast');
ylim([0 25]);
