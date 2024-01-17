%This Matlab script can be used to reproduce Figure 4.43 in the textbook:
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

%Select incident angles
varphiValues = [0 pi/6 0 pi/4];
thetaValues = [0 0 pi/4 pi/4];

%Go through all incident angles
for n = 1:length(thetaValues)

    %Extract angles
    theta = thetaValues(n);
    varphi = varphiValues(n);

    %Generate the wavevector
    wavevector = 2*pi*[cos(varphi)*cos(theta); sin(varphi)*cos(theta); sin(theta)]/lambda;


    %Select the half-length of antenna array normalized by lambda
    maxLength = 2;


    %Coordinates normalized by lambda
    spacings = 0.01; %Spacing used when generating the dense grid
    [Y,Z] = meshgrid(-maxLength:spacings:maxLength,-maxLength:spacings:maxLength);
    [Yarray,Zarray] = meshgrid(-maxLength:(1/2):maxLength,-maxLength:(1/2):maxLength);


    %Generate real-part of the wave on the surface
    phaseShifts = lambda*Y*wavevector(2)+lambda*Z*wavevector(3);
    sinusoid = cos(phaseShifts);


    %% Plot simulation results
    set(groot,'defaultAxesTickLabelInterpreter','latex');

    figure(n); box on;
    s=surf(Y,Z,sinusoid);
    set(gca,'fontsize',18);
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

end