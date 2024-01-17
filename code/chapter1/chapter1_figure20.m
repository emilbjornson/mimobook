%This Matlab script can be used to reproduce Figure 1.20 in the textbook:
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
M = 10;

%Antenna spacing in wavelengths
interAntennaSpacing = 1/2;


%Prepare to plot colors on a sphere
N = 500;
[X,Y,Z] = sphere(N);


%Angles of the user for beamforming in end fire direction
phi1 = pi/2;
theta1 = 0;

%Prepare to compute channel gains on the sphere
gainMap = zeros(size(X));

%Go through all azimuth and elevation angles
for n = 1:size(X,1)
    for m = 1:size(X,2)
        
        %Compute normalized received power according to (4.134)
        [phi2,theta2] = cart2sph(X(n,m),Y(n,m),Z(n,m));
        Psi = cos(theta2)*sin(phi2) - cos(theta1)*sin(phi1);
        
        if Psi == 0
            gainMap(n,m) = 1;
        else
            gainMap(n,m) = abs(sin(pi*M*interAntennaSpacing*Psi)/(M*sin(pi*interAntennaSpacing*Psi))).^2;
            
        end
        
    end
end

set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
surf(X,Y,Z,10*log10(gainMap),'EdgeColor','none');
xlabel('$x$','Interpreter','Latex');
ylabel('$y$','Interpreter','Latex');
zlabel('$z$','Interpreter','Latex');
caxis([-25 0]);
colormap(flipud(hot));
hBar = colorbar;
set(hBar, 'TickLabelInterpreter', 'latex');
axis equal;
set(gca,'color',[0.9 0.9 0.9]);
set(gca,'fontsize',16);
view(139.5,30);
set(gcf, 'Renderer', 'Painters');

