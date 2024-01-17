%This Matlab script can be used to reproduce Figures 2.34 and 2.35 in the textbook:
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

%Create a grid
[X,Y] = meshgrid(linspace(-5,5,1000), linspace(-5,5,1000));

%Consider a normalized wavelength
lambda = 1;

%Compute cosine wave
sinusoid = cos(2*pi*sqrt(X.^2+Y.^2)/lambda);


%Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure(1); box on; hold on; grid on;
surf(X,Y,sinusoid);
view(2);
xlabel('Distance','Interpreter','latex');
ylabel('Distance','Interpreter','latex');
colormap(autumn);
set(gca,'fontsize',16);
shading interp;
plot3(0,0,1,'k*','MarkerSize',5);
hBar = colorbar;
set(hBar, 'TickLabelInterpreter', 'latex');
hBar.Ticks = [-0.99 -0.5 0 0.5 0.99];
hBar.TickLabels = [-1 -0.5 0 0.5 1];
xticks([-5 -3 -1 0 1 3 5])
xticklabels({'$-5\lambda$','$-3\lambda$','$-\lambda$','$0$','$\lambda$','$3\lambda$','$5\lambda$'});
yticks([-5 -3 -1 0 1 3 5])
yticklabels({'$-5\lambda$','$-3\lambda$','$-\lambda$','$0$','$\lambda$','$3\lambda$','$5\lambda$'});

%Define first curve
nbrOfPoints = 500;

startPoint = [0 0]';
direction = [1 0]';
route = startPoint+direction*linspace(0,5,nbrOfPoints);
antennaLocations = startPoint+direction*(0:0.5:4.5);
sinusoid1 = cos(2*pi*sqrt(sum(route.^2,1))/lambda);
sinusoid1locations = cos(2*pi*sqrt(sum(antennaLocations.^2,1))/lambda);


figure(1);
plot3(route(1,:),route(2,:),ones(1,nbrOfPoints),'k','LineWidth',2);

figure(2); hold on; box on; grid on;
plot(linspace(0,5,nbrOfPoints),sinusoid1,'k','LineWidth',2);
plot(0:0.5:4.5,sinusoid1locations,'ko','LineWidth',2);
set(gca,'fontsize',16);
xticks(0:5)
xticklabels({'$0$','$\lambda$','$2\lambda$','$3\lambda$','$4\lambda$','$5\lambda$'});
xlabel('Distance','Interpreter','latex');


figure(3); hold on; box on; grid on;
plot(-5:4,fftshift(fft(sinusoid1locations)/sqrt(10)),'ko','LineWidth',2);
xlabel('Normalized frequency','Interpreter','latex');
ylabel('Absolute value','Interpreter','latex');
set(gca,'fontsize',16);
xticks(-5:4);
xticklabels({'$-\frac{1}{2}$','$-\frac{4}{10}$','$-\frac{3}{10}$','$-\frac{2}{10}$','$-\frac{1}{10}$','$0$','$\frac{1}{10}$','$\frac{2}{10}$','$\frac{3}{10}$','$\frac{4}{10}$'});
xlim([-5 4]);

startPoint = [1,5]';
direction = [1 -2]'/sqrt(5);
route = startPoint+direction*linspace(0,5,nbrOfPoints);
antennaLocations = startPoint+direction*(0:0.5:4.5);
sinusoid2 = cos(2*pi*sqrt(sum(route.^2,1))/lambda);
sinusoid2locations = cos(2*pi*sqrt(sum(antennaLocations.^2,1))/lambda);
figure(1);
plot3(route(1,:),route(2,:),ones(1,nbrOfPoints),'b','LineWidth',2);


figure(4); hold on; box on; grid on;
plot(linspace(0,5,nbrOfPoints),sinusoid2,'b','LineWidth',2);
plot(0:0.5:4.5,sinusoid2locations,'bo','LineWidth',2);
set(gca,'fontsize',16);
xticks(0:5)
xticklabels({'$0$','$\lambda$','$2\lambda$','$3\lambda$','$4\lambda$','$5\lambda$'});
xlabel('Distance','Interpreter','latex');

figure(5); hold on; box on; grid on;
plot(-5:4,fftshift(abs(fft(sinusoid2locations)))/sqrt(10),'bo','LineWidth',2);
xlabel('Normalized frequency','Interpreter','latex');
ylabel('Absolute value','Interpreter','latex');
set(gca,'fontsize',16);
xticks(-5:4);
xticklabels({'$-\frac{1}{2}$','$-\frac{4}{10}$','$-\frac{3}{10}$','$-\frac{2}{10}$','$-\frac{1}{10}$','$0$','$\frac{1}{10}$','$\frac{2}{10}$','$\frac{3}{10}$','$\frac{4}{10}$'});
xlim([-5 4]);


%set(gcf, 'Renderer', 'Painters');

