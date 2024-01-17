%This Matlab script can be used to reproduce Figures 5.28 and 5.32 in the textbook:
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

%Number of antennas in the ULA
M = 10;

%% Compute the beamforming gain in different directions
varphi = linspace(-pi/2,pi/2,1000);


%Generate an array response function
arrayresponse = @(x) exp(-1i*pi*(0:M-1)'*sin(x));


%Generate the array responses for the paths of the channel
directions = arrayresponse(varphi);

%Generate phase shifts for the different paths
angularDirections = [pi/6 pi/12 -pi/4 -pi/3];
phaseShifts = exp(1i*pi/3*(1:4)');

%Generate channel responses with all four paths or only one
channelResponse_4paths = arrayresponse(angularDirections)*phaseShifts;
channelResponse_1path = arrayresponse(angularDirections(1))*phaseShifts(1);

%Generate MRT vectors for the different channels
MRT_4paths = channelResponse_4paths/norm(channelResponse_4paths);
MRT_1path = channelResponse_1path/norm(channelResponse_1path);


%Compute the beampattern in all directions
beamforminggain_4paths = abs(directions'*MRT_4paths).^2;
beamforminggain_pathDirections = abs(arrayresponse(angularDirections)'*MRT_4paths).^2;
beamforminggain_1path = abs(directions'*MRT_1path).^2;


%Generate a DFT matrix to represent a grid of beams
DFTmatrix = fft(eye(M))/sqrt(M);


strengthsDFTdirections = abs(DFTmatrix'*channelResponse_4paths).^2;




%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');



figure;
ax = polaraxes;
polarplot(varphi+pi/2,pow2db(beamforminggain_4paths(:,1)),'-b','LineWidth',2)
hold on; box on; grid on;
polarplot(varphi+pi/2,pow2db(beamforminggain_1path(:,1)),'--r','LineWidth',2)
polarplot(angularDirections+pi/2,pow2db(beamforminggain_pathDirections),'k*','LineWidth',2)
polarplot(angularDirections(1)+pi/2,pow2db(M),'k*','LineWidth',2)
set(ax, 'ThetaTick', [0, 30, 60, 90, 120, 150, 180]);
set(ax, 'TickLabelInterpreter', 'latex');
set(ax, 'ThetaTickLabel',{'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
set(ax,'RLim',[-30 10]);
set(gca,'fontsize',16);
ax.ThetaLim = [0 180];
legend({'NLOS','LOS'},'Interpreter','latex','Location','Best');




figure;
hold on; box on; grid on;
bar(pow2db(strengthsDFTdirections));
xlabel('Beam index','Interpreter','latex');
ylabel('Relative channel strength [dB]','Interpreter','latex');
set(gca,'fontsize',16);
