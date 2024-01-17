%This Matlab script can be used to reproduce Figure 9.24 in the textbook:
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

%Number of setups to compare
nbrOfcases = 3;

%Set the SNR range
SNRAll = -40:1:20;

%Select the false alarm probability
PFA = 10.^(-3);

%Prepare to save simulation results
Pd = zeros(length(SNRAll),nbrOfcases);

%Select the number of random realizations
numberOfsetups = 100000;

%Select the number of antennas
K = 10;

%Select the number of atoms in the surface
N = 100;

%Define the array response of a ULA
arrayresponse_ULA = @(varphi,M) exp(-1i*pi*sin(varphi)*(0:M-1))';

%Generate the channels to the target and surface
h_s = arrayresponse_ULA(0,10);
h_c = arrayresponse_ULA(pi/6,10);



%Go through the different setups
for n = 1:nbrOfcases

    if n == 1

        %Set RCS variances with a surface
        RCSvariances = [1 1 1];

        %Optimize the precoding vector
        C = (RCSvariances(1)*norm(h_s)^2+ RCSvariances(3)*norm(h_c)^2)*conj(h_s*h_s') + (RCSvariances(2)*norm(h_c)^2+ RCSvariances(3)*norm(h_s)^2)*conj(h_c*h_c') + RCSvariances(3)*( (h_s'*h_c)*conj(h_c*h_s') + (h_c'*h_s)*conj(h_s*h_c'));

        [U,D] = eig(C);
        [~,index] = max(diag(abs(D)));
        p = U(:,index);

    elseif n == 2

        %Set RCS variances without a surface
        RCSvariances = [1 0 0];

        %MRT precoding
        p = conj(h_s)/norm(h_s);

    elseif n == 3

        %Set RCS variances with a surface
        RCSvariances = [1 1 1];

        %MRT precoding
        p = conj(h_s)/norm(h_s);

        %Compensate for having a random configuration
        h_c = h_c/sqrt(N);

    end


    %Precompute terms appearing in the expressions
    gain1 = h_s.'*p;
    gain2 = h_c.'*p;

    %Compute the covariance matrix of the effective channel
    R = RCSvariances(1)*abs(gain1)^2*(h_s*h_s') + RCSvariances(2)*abs(gain2)^2*(h_c*h_c') + RCSvariances(3)*(gain2*h_s+gain1*h_c)*(gain2*h_s+gain1*h_c)';

    %Compute eigendecomposition and extract eigenvalues
    [U,D] = eig(R);
    d = diag(D);

    %Generate y vectors with only noise
    yRealizations = sqrt(0.5)*(randn(K,numberOfsetups)+1i*randn(K,numberOfsetups));

    %Prepare to compute the thresholds
    threshold = zeros(length(SNRAll),1);

    for s = 1:length(SNRAll)

        %Extract the SNR
        rho = db2pow(SNRAll(s));

        %Generate the square root of (I+R^-1/SNR)^-1 using the eigendecomposition
        %by ignoring the eigenvectors that will only rotate the noise
        Csqrt = diag(sqrt(rho*d./(1+rho*d)));

        %Compute the threshold numerically
        [F,X] = ecdf(sum(abs(Csqrt*yRealizations).^2,1));
        [~,indexx] = min(abs(F-(1-PFA)));
        threshold(s) = X(indexx);

    end



    for s = 1:length(SNRAll)

        %Extract the SNR
        rho = db2pow(SNRAll(s));

        %Generate RCS realizations
        RCSRealizations =  diag(sqrt(RCSvariances/2))*(randn(3,numberOfsetups)+1i*randn(3,numberOfsetups));

        %Compute the effective channel, including precoding
        h = h_s * gain1 * RCSRealizations(1,:) + h_c * gain2 * RCSRealizations(2,:) + (h_s*gain2 + h_c*gain1)* RCSRealizations(3,:);

        %Generate noise realizations
        noiseRealizations = sqrt(0.5)*(randn(K,numberOfsetups)+1i*randn(K,numberOfsetups));

        %Compute the received signals
        receivedSignal = sqrt(rho)*h+noiseRealizations;

        %Generate the square root of (I+R^-1/SNR)^-1 using the eigendecomposition
        Csqrt = U*diag(sqrt(rho*d./(1+rho*d)))*U';

        %Compute the detection probability numerically
        Pd(s,n) = length(find(sum(abs(Csqrt*receivedSignal).^2,1)>=threshold(s)))/numberOfsetups;

    end

end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');


figure;
hold on; box on; grid on;
plot(SNRAll,Pd(:,2),'k','LineWidth',2);
plot(SNRAll,Pd(:,3),'r--','LineWidth',2)
plot(SNRAll,Pd(:,1),'b-.','LineWidth',1.5)
xlim([-40 20])

ax = gca;
xlabel('SNR [dB] ','Interpreter','latex');
ylabel('$P_{\rm D}$','Interpreter','latex');
legend({'No surface', 'Random', 'Optimized'},'Interpreter','latex','Location','SouthEast');
set(gca,'fontsize',16);



