%This Matlab script can be used to reproduce Figure 8.16 in the textbook:
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


%Set the radius of the circle
radiuss = 100;
receiverPositions = zeros(M,1);
for mm = 1:M
    receiverPositions(mm) = radiuss*(cos(pi/2+(mm-1)*pi/(M-1))+1i*sin(pi/2+(mm-1)*pi/(M-1)));
end


sourcePosition = radiuss+0*1i;

centers = [real(receiverPositions) imag(receiverPositions)];
radii = abs(receiverPositions-sourcePosition);
errorradii = radii+5*randn(M,1);



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

t = linspace(0.01,2*pi,1000);

for m = 1:M

    if pickCase == 1

        x1 = centers(m,1)+radii(m)*cos(t);
        y1 = centers(m,2)+radii(m)*sin(t);

        plot(x1,y1,'k','LineWidth',2);

    elseif pickCase == 2 || pickCase == 3
        % 0.1 is an arbitrary small value in the following part
        x1 = centers(m,1)+max(0.1,errorradii(m)-15)*cos(t);
        y1 = centers(m,2)+max(0.1,errorradii(m)-15)*sin(t);
        x2 = centers(m,1)+max(0.1,errorradii(m)+15)*cos(t);
        y2 = centers(m,2)+max(0.1,errorradii(m)+15)*sin(t);
        pgon = polyshape({x1,x2},{y1,y2});
        plot(pgon,'FaceColor',[1 1 0]);

    end

end

for m = 1:M

    if pickCase == 2 || pickCase == 3

        x1 = centers(m,1)+max(0.1,errorradii(m)-15)*cos(t);
        y1 = centers(m,2)+max(0.1,errorradii(m)-15)*sin(t);
        x2 = centers(m,1)+max(0.1,errorradii(m)+15)*cos(t);
        y2 = centers(m,2)+max(0.1,errorradii(m)+15)*sin(t);

        plot(x1,y1,'k','LineWidth',1);
        plot(x2,y2,'k','LineWidth',1);

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

