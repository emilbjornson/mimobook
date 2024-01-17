%This Matlab script can be used to reproduce Figure 8.17 in the textbook:
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
disDifference = abs(receiverPositions(2:end)-sourcePosition)-abs(receiverPositions(1)-sourcePosition);
errorDifference = disDifference-sqrt(2)*5*randn(M-1,1);

%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

x0 = real(sourcePosition);
y0 = imag(sourcePosition);

xval = -400:10:200;

yval1 = zeros(M-1,length(xval));
yval2 = zeros(M-1,length(xval));

figure;
hold on; box on; grid on;

for m = 1:M-1
    f = @(x,y) (sqrt((centers(m+1,1)-x).^2+(centers(m+1,2)-y).^2)-sqrt((centers(1,1)-x).^2+(centers(1,2)-y).^2));

    if pickCase == 1

        yval = zeros(1,length(xval));

        for k = 1:length(xval)

            yval(k) = fminsearch(@(y) abs(f(xval(k),y)-disDifference(m)).^2,0);

        end

        plot(xval,yval,'k','LineWidth',2);

    elseif pickCase == 2 || pickCase == 3

        for k = 1:length(xval)

            if k == 1
                yval1(m,k) = fminsearch(@(y) abs(f(xval(k),y)-(errorDifference(m)-sqrt(2)*15)).^2,-200);
                yval2(m,k) = fminsearch(@(y) abs(f(xval(k),y)-(errorDifference(m)+sqrt(2)*15)).^2,-200);
            else

                yval1(m,k) = fminsearch(@(y) abs(f(xval(k),y)-(errorDifference(m)-sqrt(2)*15)).^2,yval1(m,k-1));
                yval2(m,k) = fminsearch(@(y) abs(f(xval(k),y)-(errorDifference(m)+sqrt(2)*15)).^2,yval2(m,k-1));
            end

        end

        pgon = polyshape([xval,fliplr(xval)],[yval1(m,:),fliplr(yval2(m,:))]);
        plot(pgon,'FaceColor',[1 1 0]);

    end

end

for m = 1:M-1

    if pickCase == 2 || pickCase == 3

        plot(xval,yval1(m,:),'k','LineWidth',1);
        plot(xval,yval2(m,:),'k','LineWidth',1);

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

