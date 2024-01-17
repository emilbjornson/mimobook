%This Matlab script can be used to reproduce Figure 8.4 in the textbook:
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

rng(1)
angleGrid = linspace(-pi/2,pi/2,100000);

BF = zeros(length(angleGrid),4,2);
maxval1 = zeros(4,2);
maxind1 = zeros(4,2);
maxval2 = zeros(4,2);
maxind2 = zeros(4,2);

for trial = 1:4
    % Number of antennas
    M = 2;

    % Azimuth angles of the sources in radians
    azimAngles = [pi/6 pi/3];

    % Number of samples
    L = 25;

    % Noise variance over signal power
    sigma2 = 1;

    % Array response matrix
    arrResVec = [exp(-1i*pi*(0:(M-1))*sin(azimAngles(1))).' exp(-1i*pi*(0:(M-1))*sin(azimAngles(2))).'];

    % Random source symbols
    S = sqrt(0.5)*(randn(2,L) + 1i*randn(2,L));


    % Received signals
    Y = arrResVec*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
    Y2 = (Y*Y')/L;



    for t = 1:length(angleGrid)
        BF(t,trial,1) = real(conj(exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))))*Y2*exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))).');
    end



    % Number of antennas
    M = 10;


    % Array response matrix
    arrResVec = [exp(-1i*pi*(0:(M-1))*sin(azimAngles(1))).' exp(-1i*pi*(0:(M-1))*sin(azimAngles(2))).'];

    % Received signals
    Y = arrResVec*S + sqrt(0.5*sigma2)*(randn(M,L) + 1i*randn(M,L));
    Y2 = (Y*Y')/L;


    for t = 1:length(angleGrid)
        BF(t,trial,2) = real(conj(exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))))*Y2*exp(-1i*pi*(0:(M-1))*sin(angleGrid(t))).')/M^2;
    end

    %Find the peaks
    [peaks,locs] = findpeaks(pow2db(BF(:,trial,1)/max(BF(:,trial,1))));
    [~,indices] = sort(peaks,'descend');

    maxval1(trial,1) = peaks(indices(1));
    maxind1(trial,1) = locs(indices(1));

 

    [peaks,locs] = findpeaks(pow2db(BF(:,trial,2)/max(BF(:,trial,2))));
    [~,indices] = sort(peaks,'descend');

    maxval2(trial,1) = peaks(indices(1));
    maxind2(trial,1) = locs(indices(1));

    maxval2(trial,2) = peaks(indices(2));
    maxind2(trial,2) = locs(indices(2));
   

end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(angleGrid/pi,pow2db(BF(:,1,1)/max(BF(:,1,1))),'r','LineWidth',1.5)
plot(angleGrid/pi,pow2db(BF(:,1,2)/max(BF(:,1,2))),'b--','LineWidth',1.5)
plot(angleGrid(maxind1(1,1))/pi,maxval1(1,1),'kx','LineWidth',12)
plot(angleGrid(maxind2(1,1))/pi,maxval2(1,1),'x', 'Color', '[0.90 0.7940 0.0250]','LineWidth',12)
plot(angleGrid(maxind2(1,2))/pi,maxval2(1,2),'x', 'Color', '[0.90 0.7940 0.0250]','LineWidth',12)

ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6, 0, 1/6,  1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-10 1]);
xlabel('Angle-of-arrival $\varphi$','Interpreter','latex');
ylabel('Normalized power spectrum [dB]','Interpreter','latex');
legend({'$M=2$', '$M=10$'},'Interpreter','latex');
set(gca,'fontsize',16);
