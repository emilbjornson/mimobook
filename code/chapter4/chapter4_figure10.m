%This Matlab script can be used to reproduce Figure 4.10 in the textbook:
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

seed = 1;
rng(seed);
%Number of antennas in the ULA
Mrange = [20 10];

%Set the range of SNR values
SNRdB = 10;
SNR = db2pow(SNRdB);

%Select angle of the true channel direction
varphi_true = pi/6;

%Define array response vector
arrayresponse = @(phi,M) exp(-1i*pi*sin(phi)*(0:M-1))';


%% Compute the beamforming gain in different directions
varphi_range = linspace(-pi/2,pi/2,1000);

utilityfunction = zeros(length(varphi_range),length(Mrange));


%Go through all number of antennas
for m = 1:length(Mrange)

    M = Mrange(m);

    y_normalized = sqrt(SNR)*arrayresponse(varphi_true,M)+(randn(M,1)+1i*randn(M,1))/sqrt(2);

    for i = 1:length(varphi_range)

        utilityfunction(i,m) = real(arrayresponse(varphi_range(i),M)'*y_normalized);

    end

end

[maxval1,maxind1] = max(utilityfunction(:,1));
[maxval2,maxind2] = max(utilityfunction(:,2));

%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(varphi_range/pi,utilityfunction(:,1),'-b','LineWidth',2)
plot(varphi_range/pi,utilityfunction(:,2),'k-.','LineWidth',2)
plot(varphi_range(maxind1)/pi,maxval1,'b*','LineWidth',2)
plot(varphi_range(maxind2)/pi,maxval2,'k*','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
xlabel('Angle-of-arrival $\varphi$','Interpreter','latex');
ylabel('Normalized utility function','Interpreter','latex');
legend({'$M=20$','$M=10$'},'Location','NorthWest','Interpreter','latex')
set(gca,'fontsize',16);
ylim([-20 60]);
