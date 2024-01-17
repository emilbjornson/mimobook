%This Matlab script can be used to reproduce Figure 8.2 in the textbook:
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


%Set maximum number of samples
Lmax = 100;
Lrange = (20:10:Lmax);
numTrial = 5000;
angleGrid = linspace(0,pi/3,10000);

BF = zeros(length(angleGrid),2);
MSE1 = zeros(length(Lrange),2);
MSE2 = zeros(length(Lrange),2);

% Azimuth angles of the sources in radians
azimAngles = pi/6;

sigma2All = [1 0.1];

for trial = 1:numTrial
    

    for noiseSel = 1:2

        sigma2 = sigma2All(noiseSel);





        for l = 1:length(Lrange)
            L = Lrange(l);
            % Random source symbols
            S = sqrt(0.5)*(randn(1,L) + 1i*randn(1,L));

            % Number of antennas
            M = 2;

            % Array response matrix
            arrResVec = exp(-1i*pi*(0:(M-1))*sin(azimAngles(1))).';

            % Received signals
            Y = arrResVec*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
            Y2 = (Y*Y')/L;



            for t = 1:length(angleGrid)
                BF(t,1) = real(conj(exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))))*Y2*exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))).');
            end



            % Number of antennas
            M = 10;

            % Array response matrix
            arrResVec = exp(-1i*pi*(0:(M-1))*sin(azimAngles(1))).';

            % Received signals
            Y = arrResVec*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
            Y2 = (Y*Y')/L;


            for t = 1:length(angleGrid)
                BF(t,2) = real(conj(exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))))*Y2*exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))).')/M^2;
            end
            [~,maxind1] = max(BF(:,1));
            [~,maxind2] = max(BF(:,2));

            MSE1(l,noiseSel) = MSE1(l,noiseSel) + (angleGrid(maxind1)-azimAngles)^2/numTrial;
            MSE2(l,noiseSel) = MSE2(l,noiseSel) + (angleGrid(maxind2)-azimAngles)^2/numTrial;

        end
    end
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(Lrange.',MSE1(:,1),'k:','LineWidth',2);
plot(Lrange.',MSE1(:,2),'k','LineWidth',2);
plot(Lrange.',MSE2(:,1),'r--','LineWidth',2);
plot(Lrange.',MSE2(:,2),'b-.','LineWidth',2);
xlabel('Number of samples ($L$)','Interpreter','latex');
ylabel('MSE','Interpreter','latex');
legend({'$M=2$, $\textrm{SNR}=0$\,dB', '$M=2$, $\textrm{SNR}=10$\,dB' '$M=10$, $\textrm{SNR}=0$\,dB','$M=10$, $\textrm{SNR}=10$\,dB'},'Interpreter','latex');
set(gca,'YScale','log');
set(gca,'fontsize',16);
xlim([20 100])
ylim([8e-7 0.3]);
