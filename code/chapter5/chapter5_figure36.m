%This Matlab script can be used to reproduce Figure 5.36 in the textbook:
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

%Set the wavelength (the value doesn't matter)
lambda = 2;


%Select the length of antenna array normalized by lambda
maxLength = 2;


%Coordinates normalized by lambda
spacings = 0.01; %Spacing used when generating the dense grid
[Y,Z] = meshgrid(-maxLength:spacings:maxLength,-maxLength:spacings:maxLength);
[Yarray,Zarray] = meshgrid(-maxLength:(1/2):maxLength,-maxLength:(1/2):maxLength);



%% Part (a)

%Select the angles of the four plane waves
varphi = [pi/6 pi/12 -pi/4 -pi/3];
theta = [pi/6 -pi/4 0 pi/3];

%Compute the real part of the impinging wave on the surface
sinusoidPlanar = zeros(size(Y));
sinusoidPlanarArray = zeros(size(Yarray));

for n = 1:length(varphi)

    %For a dense grid
    phaseShifts = lambda*(Y*sin(varphi(n))*cos(theta(n)) + Z*sin(theta(n)));
    sinusoidPlanar = sinusoidPlanar + exp(1i*2*pi*phaseShifts/lambda)*exp(1i*(n-1)*pi/3)/length(varphi);


    %At the antenna locations
    phaseShiftsArray = lambda*(Yarray*sin(varphi(n))*cos(theta(n)) + Zarray*sin(theta(n)));
    sinusoidPlanarArray = sinusoidPlanarArray + exp(1i*2*pi*phaseShiftsArray/lambda)*exp(1i*(n-1)*pi/3)/length(varphi);

end




%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure; box on;
s=surf(Y,Z,real(sinusoidPlanar));
set(gca,'fontsize',16);
xlabel('$y$','Interpreter','Latex');
ylabel('$z$','Interpreter','Latex');
xticks(-2:1:2);
yticks(-2:1:2);
xticklabels({'$-2\lambda$','$-\lambda$','$0$','$\lambda$','$2\lambda$'});
yticklabels({'$-2\lambda$','$-\lambda$','$0$','$\lambda$','$2\lambda$'});
view(2);
s.EdgeColor = 'none';
shading interp;
clim([-1 1]);
hBar = colorbar;
colormap(autumn);
set(hBar, 'TickLabelInterpreter', 'latex');
axis square;
hold on;
plot3(Yarray,Zarray,1.1*ones(size(Zarray)),'ko','MarkerFaceColor','#000000');

set(gcf, 'Renderer', 'Painters');



%Compute the 2D-DFT and wrap it to have the zero frequency in the middle
DFT2 = fft2(sinusoidPlanarArray);
DFT2wrap = [DFT2(ceil(length(DFT2)/2)+1:end,:); DFT2(1:ceil(length(DFT2)/2),:)];
DFT2wrap = [DFT2wrap(:,ceil(length(DFT2)/2)+1:end) DFT2wrap(:,1:ceil(length(DFT2)/2))];


set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
b = bar3(abs(DFT2wrap));

for m = 1:length(b)
    zdata = b(m).ZData;
    b(m).CData = zdata;
    b(m).FaceColor = 'interp';
end
colormap(hot);


xticklabels({'$-\frac{8}{9\lambda}$','$-\frac{6}{9\lambda}$','$-\frac{4}{9\lambda}$','$-\frac{2}{9\lambda}$','$0$','$\frac{2}{9\lambda}$','$\frac{4}{9\lambda}$','$\frac{6}{9\lambda}$','$\frac{8}{9\lambda}$'});
yticklabels({'$-\frac{8}{9\lambda}$','$-\frac{6}{9\lambda}$','$-\frac{4}{9\lambda}$','$-\frac{2}{9\lambda}$','$0$','$\frac{2}{9\lambda}$','$\frac{4}{9\lambda}$','$\frac{6}{9\lambda}$','$\frac{8}{9\lambda}$'});

xlabel('Horizontal spatial frequencies','Interpreter','Latex');
ylabel('Vertical spatial frequencies','Interpreter','Latex');
zlabel('Magnitude of DFT','Interpreter','Latex');
set(gca,'fontsize',13);
set(gcf, 'Renderer', 'Painters');





%% Part (b)


%Set the propagation distance for the nearby transmitter
d = 8;



%Generate real-part of the wave on the surface
phaseShifts = lambda*sqrt(Y.^2+Z.^2+d^2);
phaseVector = cos(2*pi*phaseShifts/lambda);


%Generate real-part of the wave on the antenna locations
phaseShiftsArray = lambda*sqrt(Yarray.^2+Zarray.^2+d^2);
phaseVectorArray = exp(1i*2*pi*phaseShiftsArray/lambda);


 
%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure; box on;
s=surf(Y,Z,phaseVector);
set(gca,'fontsize',16);
xlabel('$y$','Interpreter','Latex');
ylabel('$z$','Interpreter','Latex');
xticks(-2:1:2);
yticks(-2:1:2);
xticklabels({'$-2\lambda$','$-\lambda$','$0$','$\lambda$','$2\lambda$'});
yticklabels({'$-2\lambda$','$-\lambda$','$0$','$\lambda$','$2\lambda$'});
view(2);
s.EdgeColor = 'none';
shading interp;
clim([-1 1]);
hBar = colorbar;
colormap(autumn);
set(hBar, 'TickLabelInterpreter', 'latex');
axis square;

hold on;
plot3(Yarray,Zarray,1.1*ones(size(Zarray)),'ko','MarkerFaceColor','#000000');

set(gcf, 'Renderer', 'Painters');




%Compute the 2D-DFT and wrap it to have the zero frequency in the middle
DFT2 = fft2(phaseVectorArray);
DFT2wrap = [DFT2(ceil(length(DFT2)/2)+1:end,:); DFT2(1:ceil(length(DFT2)/2),:)];
DFT2wrap = [DFT2wrap(:,ceil(length(DFT2)/2)+1:end) DFT2wrap(:,1:ceil(length(DFT2)/2))];


set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
b = bar3(abs(DFT2wrap));

for m = 1:length(b)
    zdata = b(m).ZData;
    b(m).CData = zdata;
    b(m).FaceColor = 'interp';
end
colormap(hot);


xticklabels({'$-\frac{8}{9\lambda}$','$-\frac{6}{9\lambda}$','$-\frac{4}{9\lambda}$','$-\frac{2}{9\lambda}$','$0$','$\frac{2}{9\lambda}$','$\frac{4}{9\lambda}$','$\frac{6}{9\lambda}$','$\frac{8}{9\lambda}$'});
yticklabels({'$-\frac{8}{9\lambda}$','$-\frac{6}{9\lambda}$','$-\frac{4}{9\lambda}$','$-\frac{2}{9\lambda}$','$0$','$\frac{2}{9\lambda}$','$\frac{4}{9\lambda}$','$\frac{6}{9\lambda}$','$\frac{8}{9\lambda}$'});

xlabel('Horizontal spatial frequencies','Interpreter','Latex');
ylabel('Vertical spatial frequencies','Interpreter','Latex');
zlabel('Magnitude of DFT','Interpreter','Latex');
set(gca,'fontsize',13);
set(gcf, 'Renderer', 'Painters');


