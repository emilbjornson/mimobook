%This Matlab script can be used to reproduce Figure 7.11 in the textbook:
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

%Number of transmit antennas
K = 5; 

%Create DFT beam directions
clusterAngles = [0 25 -35]*pi/180;
H = exp(-1i*pi*(0:K-1)'*sin(clusterAngles)); 

%Discrete time delays of the paths via the three clusters
delaysDiscrete = [3 4 5]';

%Relative strength of the taps, when considering one or three clusters
gains1 = [1 0 0]';
gains3 = [1 1 1]'.*exp(1i*(1:3)'*pi/3);

%Number of taps 
T = 10;
t = 0:T;

%Generate the channel taps
tapValues1 = zeros(T+1,length(delaysDiscrete));
tapValues3 = zeros(T+1,length(delaysDiscrete));

for k = 1:length(delaysDiscrete)
    tapValues1(:,k) = gains1(k)*sinc(t-delaysDiscrete(k));
    tapValues3(:,k) = gains3(k)*sinc(t-delaysDiscrete(k));
end



%Number of angles to consider when plotting the graph
N = 100;
angleInterval = linspace(-pi/2,pi/2,N);

%Generate the corresponding ULA array response vectors
arrayResponses = zeros(K,N);

for n = 1:N
    
    arrayResponses(:,n) = exp(-1i*pi*(0:K-1)'*sin(angleInterval(n)));
 
end


%Number of subcarriers
S = 200;

%Generate the DFT matrix needed for OFDM
DFT_S = fft(eye(S));
DFT_ST = DFT_S(:,1:T+1);

%Compute the DFT of the taps
tapResponses1 = DFT_ST*tapValues1;
tapResponses3 = DFT_ST*tapValues3;

%Compute the subcarrier channels
subcarrierChannels1 = tapResponses1 * H.';
subcarrierChannels3 = tapResponses3 * H.';

%Compute the effective channels with different beam directions
subcarrierPowers1 = abs(subcarrierChannels1*conj(arrayResponses)).^2;
subcarrierPowers1 = subcarrierPowers1/max(subcarrierPowers1(:));

subcarrierPowers3 = abs(subcarrierChannels3*conj(arrayResponses)).^2;
subcarrierPowers3 = subcarrierPowers3/max(subcarrierPowers3(:));


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure(1);
mesh(180*angleInterval/pi,1:S,pow2db(abs(subcarrierPowers1).^2));
xlabel('Beam angle [degrees]','Interpreter','latex')
ylabel('Subcarrier index','Interpreter','latex');
zlabel('Relative channel gain [dB]','Interpreter','latex');
set(gca,'fontsize',20);
colormap(jet);
zlim([-50 0]);
xlim([-90 90]);
set(gca, 'XTick', [-90, -60, -30 0 30 60, 90]);
set(gca, 'YTick', [1 50 100 150 200]);
view(-26,27);
set(gcf, 'Renderer', 'Painters');



figure(2);
mesh(180*angleInterval/pi,1:S,pow2db(abs(subcarrierPowers3).^2));
xlabel('Beam angle [degrees]','Interpreter','latex')
ylabel('Subcarrier index','Interpreter','latex');
zlabel('Relative channel gain [dB]','Interpreter','latex');
set(gca,'fontsize',20);
colormap(jet);
zlim([-50 0]);
xlim([-90 90]);
set(gca, 'XTick', [-90, -60, -30 0 30 60, 90]);
set(gca, 'YTick', [1 50 100 150 200]);
view(-26,27);
set(gcf, 'Renderer', 'Painters');
