%This Matlab script can be used to reproduce Figure 8.14 in the textbook:
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
M = 50;
Mh = 10;
Mv = 5;

% Number of sources
K = 4;

%Fix the random seed for reproducibility purposes
rng(0);

% Azimuth angles of the sources in radians
azimAngles = [ pi/20; -pi/20; pi/20; -pi/20 ];

% Elevation angles of the sources in radians
elevAngles = [  pi/20;   pi/20; -pi/20; -pi/20 ];

% Number of samples
L = 50;

% Array response matrix
arrayResponseVector1a = exp(-1i*pi*(0:(Mh-1))*sin(azimAngles(1))*cos(elevAngles(1))).';
arrayResponseVector2a = exp(-1i*pi*(0:(Mv-1))*sin(elevAngles(1))).';

arrayResponseVector1b = exp(-1i*pi*(0:(Mh-1))*sin(azimAngles(2))*cos(elevAngles(2))).';
arrayResponseVector2b = exp(-1i*pi*(0:(Mv-1))*sin(elevAngles(2))).';

arrayResponseVector1c = exp(-1i*pi*(0:(Mh-1))*sin(azimAngles(3))*cos(elevAngles(3))).';
arrayResponseVector2c = exp(-1i*pi*(0:(Mv-1))*sin(elevAngles(3))).';

arrayResponseVector1d = exp(-1i*pi*(0:(Mh-1))*sin(azimAngles(4))*cos(elevAngles(4))).';
arrayResponseVector2d = exp(-1i*pi*(0:(Mv-1))*sin(elevAngles(4))).';


A = [ kron(arrayResponseVector1a,arrayResponseVector2a) ...
    kron(arrayResponseVector1b,arrayResponseVector2b) ...
    kron(arrayResponseVector1c,arrayResponseVector2c) ...
    kron(arrayResponseVector1d,arrayResponseVector2d)];

% Random source symbols
S = sqrt(0.5)*(randn(K,L) + 1i*randn(K,L));

% Noise variance
sigma2 = 1;

% Received signals
Y = A*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
Y2 = (Y*Y')/L;

[U,D] = eig(Y2);
[~,indexxSort] = sort(real(diag(D)),'descend');
U2 = U(:,indexxSort(5:end));
NoiseProj = (U2*U2');


angleGrid = linspace(-pi/16,pi/16,300);

[azimGrid,elevGrid] = meshgrid(angleGrid, angleGrid);


BF = zeros(size(azimGrid));
BF2 = zeros(size(azimGrid));

for t = 1:length(angleGrid)
    for t2 = 1:length(angleGrid)
        arrayResponseVector1 = exp(-1i*pi*(0:(Mh-1))*sin(azimGrid(t,t2))*cos(elevGrid(t,t2))).';
        arrayResponseVector2 = exp(-1i*pi*(0:(Mv-1))*sin(elevGrid(t,t2))).';
        arrayResponseVector = kron(arrayResponseVector1,arrayResponseVector2);

        BF(t,t2) = 1/real((arrayResponseVector'/Y2)*arrayResponseVector);
        BF2(t,t2) = 1/abs(arrayResponseVector'*NoiseProj*arrayResponseVector);

    end
end

%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
surf(azimGrid/pi, elevGrid/pi, BF/max(max(BF)),'EdgeColor','none');

yline(1/20,'r--','LineWidth',2)
yline(-1/20,'r--','LineWidth',2)
xline(1/20,'r--','LineWidth',2)
xline(-1/20,'r--','LineWidth',2)


ax = gca;
set(ax, 'XTick', [-0.5, -1/4, -1/20, 0, 1/20, 1/4, 1/2]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{4}$','$-\frac{\pi}{20}$','$0$', '$\frac{\pi}{20}$','$\frac{\pi}{4}$','$\frac{\pi}{2}$'});
set(ax, 'YTick', [-0.5, -1/3, -1/20, 0,1/20, 1/4, 1/2]);
yticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$', '$-\frac{\pi}{20}$','$0$', '$\frac{\pi}{20}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
xlabel('Azimuth angle ($\varphi$)','Interpreter','latex');
ylabel('Elevation angle ($\theta$)','Interpreter','latex');
set(gca,'fontsize',14);
axis square
xlim([min(angleGrid/pi) max(angleGrid/pi)]);
ylim([min(angleGrid/pi) max(angleGrid/pi)]);
shading interp;
view(0,90)
hBar = colorbar;
caxis([0, 1]);
set(hBar, 'TickLabelInterpreter', 'latex');
set(gcf, 'Renderer', 'Painters');

figure;
hold on; box on; grid on;
surf(azimGrid/pi, elevGrid/pi, BF2/max(max(BF2)),'EdgeColor','none');

yline(1/20,'r--','LineWidth',2)
yline(-1/20,'r--','LineWidth',2)
xline(1/20,'r--','LineWidth',2)
xline(-1/20,'r--','LineWidth',2)

ax = gca;
set(ax, 'XTick', [-0.5, -1/4, -1/20, 0, 1/20, 1/4, 1/2]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{4}$','$-\frac{\pi}{20}$','$0$', '$\frac{\pi}{20}$','$\frac{\pi}{4}$','$\frac{\pi}{2}$'});
set(ax, 'YTick', [-0.5, -1/3, -1/20, 0,1/20, 1/3, 1/2]);
yticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$', '$-\frac{\pi}{20}$','$0$', '$\frac{\pi}{20}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
xlabel('Azimuth angle ($\varphi$)','Interpreter','latex');
ylabel('Elevation angle ($\theta$)','Interpreter','latex');
set(gca,'fontsize',14);
axis square
xlim([min(angleGrid/pi) max(angleGrid/pi)]);
ylim([min(angleGrid/pi) max(angleGrid/pi)]);
shading interp;
view(0,90)
hBar = colorbar;
caxis([0, 1]);
set(hBar, 'TickLabelInterpreter', 'latex');
set(gcf, 'Renderer', 'Painters');
