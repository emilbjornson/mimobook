%This Matlab script can be used to reproduce Figure 8.9 in the textbook:
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

% Number of antennas
M = 16;
Mh = 16;
Mv = 1;

% Number of sources
K = 1;

%Fix the random seed for reproducibility purposes
rng(0);

% Azimuth angle of the sources in radians
azimAngles = pi/4;

% Elevation angle of the sources in radians
elevAngles = -pi/4;

% Number of samples
L = 25;

% Array response matrix
arrayResponseVector1 = exp(-1i*pi*(0:(Mh-1))*sin(azimAngles)*cos(elevAngles)).';
arrayResponseVector2 = exp(-1i*pi*(0:(Mv-1))*sin(elevAngles)).';

A = kron(arrayResponseVector1,arrayResponseVector2);

% Random source symbols
S = sqrt(0.5)*(randn(K,L) + 1i*randn(K,L));

% Noise variance
sigma2 = 1;

% Received signals
Y = A*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
Y2 = (Y*Y')/L;

angleGrid = linspace(-pi/2,pi/2,300);

[azimGrid,elevGrid] = meshgrid(angleGrid, angleGrid);


BF = zeros(size(azimGrid));

for t = 1:length(angleGrid)
    for t2 = 1:length(angleGrid)
        arrayResponseVector1 = exp(-1i*pi*(0:(Mh-1))*sin(azimGrid(t,t2))*cos(elevGrid(t,t2))).';
        arrayResponseVector2 = exp(-1i*pi*(0:(Mv-1))*sin(elevGrid(t,t2))).';
        arrayResponseVector = kron(arrayResponseVector1,arrayResponseVector2);

        BF(t,t2) = 1/real((arrayResponseVector'/Y2)*arrayResponseVector);

    end
end

%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
surf(azimGrid/pi, elevGrid/pi, BF/max(max(BF)),'EdgeColor','none');
Z = BF/max(max(BF));
ZMax=max(Z(:));
plot3(1/6,0,ZMax,'rx','LineWidth',14)
plot3(1/4,-1/4,ZMax,'go','LineWidth',8)
plot3(1/4,1/4,ZMax,'ro','LineWidth',8)
plot3(1/2,1/3,ZMax,'rp','LineWidth',4)
plot3(1/2,-1/3,ZMax,'rp','LineWidth',4)
ax = gca;
set(ax, 'XTick', [-0.5, -1/4, -1/6, 0, 1/6, 1/4, 1/2]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{4}$','$-\frac{\pi}{6}$','$0$', '$\frac{\pi}{6}$','$\frac{\pi}{4}$','$\frac{\pi}{2}$'});
set(ax, 'YTick', [-0.5, -1/3, -1/4, 0,1/4, 1/3, 1/2]);
yticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$', '$-\frac{\pi}{4}$','$0$', '$\frac{\pi}{4}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
xlabel('Azimuth angle ($\varphi$)','Interpreter','latex');
ylabel('Elevation angle ($\theta$)','Interpreter','latex');
set(gca,'fontsize',14);
axis square;
shading interp;
view(0,90)
hBar = colorbar;
caxis([0, 1]);
set(hBar, 'TickLabelInterpreter', 'latex');
set(gcf, 'Renderer', 'Painters');
