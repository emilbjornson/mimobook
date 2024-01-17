%This Matlab script can be used to reproduce Figure 9.8 in the textbook:
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

%Length of the surface
Llambda = [1/2 1/6];

%% Compute the beamforming gain in different directions
varphi = linspace(-pi/2,pi/2,2000);
beamforminggain = zeros(length(varphi),length(Llambda));

incidentAngle = pi/6;



for i = 1:length(varphi)

    Psi = sin(varphi(i))+sin(incidentAngle);



    for m = 1:length(Llambda)

        factor1 = 1e-8*(4*pi)^2*Llambda(m)^4;

        beamforminggain(i,m) = factor1*sinc(Llambda(m)*Psi).^2;

    end

end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');



figure;
ax = polaraxes;
polarplot(varphi+pi/2,pow2db(beamforminggain(:,1)),'-b','LineWidth',2);
hold on; box on; grid on;
polarplot(varphi+pi/2,pow2db(beamforminggain(:,2)),'--r','LineWidth',2);
set(ax, 'ThetaTick', [0, 30, 60, 90, 120, 150, 180]);
set(ax, 'TickLabelInterpreter', 'latex');
set(ax, 'ThetaTickLabel',{'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
set(ax,'RLim',[-95 -65]);
set(gca,'fontsize',16);
ax.ThetaLim = [0 180];
legend({'$L = \lambda/2$','$L = \lambda/6$'},'Interpreter','Latex','Location','best');
