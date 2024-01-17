%This Matlab script can be used to reproduce Figure 4.39 in the textbook:
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

%Number of horizontal antennas
Mh = 10;

%Number of vertical antennas
Mv = 4;


thetaRange = [0 pi/4];

%% Compute the beamforming gain in different azimuth directions
varphi = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(varphi),length(thetaRange));

for m = 1:length(thetaRange)

    Omega = sin(thetaRange(m));

    if Omega == 0
        factorV = Mv;
    else
        factorV = abs(sin(Mv*Omega*pi/2)/sin(Omega*pi/2))^2/Mv;
    end

    for i = 1:length(varphi)

        Psi = cos(thetaRange(m))*sin(varphi(i));

        if Psi == 0
            factorH = Mh;
        else
            factorH = abs(sin(Mh*Psi*pi/2)/sin(Psi*pi/2))^2/Mh;
        end


        beamforminggain(i,m) = factorH*factorV;

    end

end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(beamforminggain(:,1)),'r--','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,2)),'-b','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-20 20]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'$\theta=0$', '$\theta=\pi/4$'},'Interpreter','latex');
set(gca,'fontsize',16);
