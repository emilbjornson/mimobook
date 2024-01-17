%This Matlab script can be used to reproduce Figure 1.17 in the textbook:
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
clear


%Transmit power in mW
%(100 mW for Figure 1.17a and 1000 mW for Figure 1.17b)
transmitPower = 100;

%Wavelength at 3 GHz (in meters)
lambda = 0.1;

%Constant term when computing pathloss with an isotropic antenna
constant = lambda^2/(4*pi)^2;

%Number of antennas
M = 10;

%Angle of the beamforming
beamformingAngle = 0;

%Antenna spacing in wavelengths
interAntennaSpacing = 1/2;


%Define the simulation area (in meters)
maxDistance = 100;

%Generate the x range and y range of the simulation area
x = [-maxDistance:1:-maxDistance/8 -maxDistance/8+0.1:0.1:maxDistance/8 maxDistance/8+1:1:maxDistance];
y = [-maxDistance:1:-maxDistance/8 -maxDistance/8+0.1:0.1:maxDistance/8 maxDistance/8+1:1:maxDistance];


%Compute angle and distance to all points
anglevalues = zeros(length(x),length(y));
distances = zeros(length(x),length(y));

for k = 1:length(x)

    for j = 1:length(y)

        anglevalues(k,j) = angle(x(k)+1i*y(j));
        distances(k,j) = abs(x(k)+1i*y(j));

    end

end

anglevalues = anglevalues(:);
distances = distances(:);


%Ignore the point in the center at zero distance
distances(distances==0) = 1;


%Compute beamforming vector in the direction of interest
hbeamforming = exp(-1i*2*pi*interAntennaSpacing*(0:M-1)'*sin(beamformingAngle));
hbeamforming = hbeamforming/norm(hbeamforming);

%Compute the channel vector to all locations in the area
hvectors = exp(-1i*2*pi*interAntennaSpacing*(0:M-1)'*sin(anglevalues'));

%Compute the effective channel gain to all the locations
gains = constant*abs(hvectors'*hbeamforming).^2./(distances).^2;


gain = reshape(gains,[length(x), length(y)]);

gain(gain<10^(-9)) = 10^(-9);



set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;

surf(x,y,10*log10(transmitPower*gain)');
caxis([-60 -10]);
colormap(flipud(hot));
hBar = colorbar;
set(hBar, 'TickLabelInterpreter', 'latex');
view([0 90]);
shading interp;
hold on;
plot(0,0,'ko','MarkerSize',5,'MarkerFaceColor','k');

hold off;
xlabel('Distance [m]','Interpreter','Latex');
ylabel('Distance [m]','Interpreter','Latex');
axis square
set(gca,'fontsize',16);
set(gca,'Color','none');
set(gcf, 'Renderer', 'Painters');





