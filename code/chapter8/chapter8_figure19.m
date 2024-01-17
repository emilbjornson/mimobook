%This Matlab script can be used to reproduce Figure 8.19 in the textbook:
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

%Select which subfigure to plot
pickCase = 1;


if pickCase == 1

    %Number of antennas
    M = 3;

elseif pickCase == 2

    %Number of antennas
    M = 3;

elseif pickCase == 3

    %Number of antennas
    M = 10;

end


radiuss = 100;
receiverPositions = zeros(M,1);
for mm = 1:M
    receiverPositions(mm) = radiuss*(cos(pi/2+(mm-1)*pi/(M-1))+1i*sin(pi/2+(mm-1)*pi/(M-1)));
end


sourcePosition = radiuss+0*1i;
centers = [real(receiverPositions) imag(receiverPositions)];
AoA = angle(receiverPositions-sourcePosition);
errorAoA = AoA+4/180*pi*randn(M,1);

%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

x0 = real(sourcePosition);
y0 = imag(sourcePosition);

figure;
hold on; box on; grid on;
for m = 1:M
    

    if pickCase == 1

        xval = centers(m,1):1:200;
        y1 = tan(AoA(m))*xval + centers(m,2)-tan(AoA(m))*centers(m,1);

        plot(xval,y1,'k','LineWidth',2);

    elseif pickCase == 2 || pickCase == 3

        xval = centers(m,1):1:200;
        yval1 = tan(AoA(m)-12/180*pi)*xval + centers(m,2)-tan(AoA(m)-12/180*pi)*centers(m,1);
        yval2 = tan(AoA(m)+12/180*pi)*xval + centers(m,2)-tan(AoA(m)+12/180*pi)*centers(m,1);

        pgon = polyshape([xval,fliplr(xval)],[yval1,fliplr(yval2)]);
        plot(pgon,'FaceColor',[1 1 0]);

    end


end

if pickCase == 2 || pickCase == 3

    for m = 1:M
        xval = centers(m,1):1:200;
        yval1 = tan(AoA(m)-12/180*pi)*xval + centers(m,2)-tan(AoA(m)-12/180*pi)*centers(m,1);
        yval2 = tan(AoA(m)+12/180*pi)*xval + centers(m,2)-tan(AoA(m)+12/180*pi)*centers(m,1);

        plot(xval,yval1,'k','LineWidth',1);
        plot(xval,yval2,'k','LineWidth',1);


    end

end

xlim([-400 200]);
ylim([-300 300]);
plot(receiverPositions,'bs','MarkerFaceColor','b','MarkerSize',12);
plot(sourcePosition,0,'rh','MarkerFaceColor','r','MarkerSize',12);

ax = gca;
set(ax, 'XTick', -400:100:200);
set(ax, 'YTick', -300:100:300);
xlabel('$x$ [m]','Interpreter','latex');
ylabel('$y$ [m]','Interpreter','latex');
set(gca,'fontsize',20);
axis square % Set the axis aspect ratio to 1:1.
