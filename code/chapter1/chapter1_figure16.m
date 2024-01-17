%This Matlab script can be used to reproduce Figure 1.16 in the textbook:
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
transmitPower = 1000; 

%Wavelength at 3 GHz (in meters)
lambda = 0.1;

%Constant term when computing pathloss with an isotropic antenna
constant = lambda^2/(4*pi)^2;


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

%Compute the effective channel gain to all the locations
gains = constant./(distances).^2;

gain = reshape(gains,[length(x), length(y)]);


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
