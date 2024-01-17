%This Matlab script can be used to reproduce Figure 4.41 in the textbook:
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

%Number of antennas
Mh = 10;
Mv = 4;


%Antenna spacing in wavelengths
interAntennaSpacing = 1/2;


%Prepare to plot colors on a sphere
N = 500;
[X,Y,Z] = sphere(N);




%%Beamforming in boresight direction using a UPA


%Angles of the user
phi1 = 0;
theta1 = 0;

%Prepare to compute channel gains on the sphere
gainMap = zeros(size(X));

%Go through all azimuth and elevation angles
for n = 1:size(X,1)
    for m = 1:size(X,2)
        
        [phi2,theta2] = cart2sph(X(n,m),Y(n,m),Z(n,m));
        Psi = cos(theta1)*sin(phi1) - cos(theta2)*sin(phi2);
        Omega = sin(theta1) - sin(theta2);

        if (Psi == 0) && (Omega == 0)
            gainMap(n,m) = Mh*Mv;
        elseif Psi == 0
            gainMap(n,m) = Mh*(1/Mv)*abs(sin(pi*Mv*interAntennaSpacing*Omega)/(sin(pi*interAntennaSpacing*Omega)))^2;
        elseif Omega == 0 
            gainMap(n,m) = Mv*(1/Mh)*abs(sin(pi*Mh*interAntennaSpacing*Psi)/(sin(pi*interAntennaSpacing*Psi)))^2;
        else
            gainMap(n,m) = (1/Mv)*abs(sin(pi*Mv*interAntennaSpacing*Omega)/(sin(pi*interAntennaSpacing*Omega)))^2 ...
                *(1/Mh)*abs(sin(pi*Mh*interAntennaSpacing*Psi)/(sin(pi*interAntennaSpacing*Psi)))^2;

        end
        
    end
end

varphiAngles = linspace(-pi/2,pi/2,100);
thetaAngles = linspace(-pi/2,pi/2,100);

x_circ = cos(varphiAngles);
y_circ = sin(varphiAngles);

x_circ2 = cos(thetaAngles);
z_circ2 = sin(thetaAngles);
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure(1);
surf(X,Y,Z,10*log10(gainMap),'EdgeColor','none');
xlabel('$x$','Interpreter','Latex');
ylabel('$y$','Interpreter','Latex');
zlabel('$z$','Interpreter','Latex');
caxis([-20 20]);
colormap(flipud(hot));
hBar = colorbar;
set(hBar, 'TickLabelInterpreter', 'latex');
axis equal;
set(gca,'color',[0.9 0.9 0.9]);
set(gca,'fontsize',16);
view(122,30);
xlim([0 1]);
hold on;
plot3(x_circ,y_circ,zeros(size(x_circ)),'k:','LineWidth',2);
plot3(x_circ2,zeros(size(x_circ2)),z_circ2,'b--','LineWidth',1.5);
set(gcf, 'Renderer', 'Painters');


%%Beamforming in boresight direction using a ULA

%Number of antennas
Mh = 10;
Mv = 1;


%Compute interference gains on the sphere
gainMap = zeros(size(X));

for n = 1:size(X,1)
    for m = 1:size(X,2)
        
        [phi2,theta2] = cart2sph(X(n,m),Y(n,m),Z(n,m));
        Psi = cos(theta1)*sin(phi1) - cos(theta2)*sin(phi2);
        Omega = sin(theta1) - sin(theta2);

        if (Psi == 0) && (Omega == 0)
            gainMap(n,m) = Mh*Mv;
        elseif Psi == 0
            gainMap(n,m) = Mh*(1/Mv)*abs(sin(pi*Mv*interAntennaSpacing*Omega)/(sin(pi*interAntennaSpacing*Omega)))^2;
        elseif Omega == 0 
            gainMap(n,m) = Mv*(1/Mh)*abs(sin(pi*Mh*interAntennaSpacing*Psi)/(sin(pi*interAntennaSpacing*Psi)))^2;
        else
            gainMap(n,m) = (1/Mv)*abs(sin(pi*Mv*interAntennaSpacing*Omega)/(sin(pi*interAntennaSpacing*Omega)))^2 ...
                *(1/Mh)*abs(sin(pi*Mh*interAntennaSpacing*Psi)/(sin(pi*interAntennaSpacing*Psi)))^2;

        end
        
        
    end
end

figure(2);
surf(X,Y,Z,10*log10(gainMap),'EdgeColor','none');
xlabel('$x$','Interpreter','Latex');
ylabel('$y$','Interpreter','Latex');
zlabel('$z$','Interpreter','Latex');
caxis([-20 20]);
colormap(flipud(hot));
hBar = colorbar;
set(hBar, 'TickLabelInterpreter', 'latex');
axis equal;
set(gca,'color',[0.9 0.9 0.9]);
set(gca,'fontsize',16);
view(122,30);
xlim([0 1]);
hold on;
plot3(x_circ,y_circ,zeros(size(x_circ)),'k:','LineWidth',2);
plot3(x_circ2,zeros(size(x_circ2)),z_circ2,'b--','LineWidth',1.5);
set(gcf, 'Renderer', 'Painters');
