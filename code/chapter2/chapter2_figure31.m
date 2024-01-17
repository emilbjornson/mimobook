%This Matlab script can be used to reproduce Figure 2.31 in the textbook:
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

S = 7; %odd number

frequencies = [0:(S-1)/2 -(S-1)/2:-1];

integerSamples = (0:S-1);
realSamples = linspace(0,S-1,1000);

sampledValues = exp(1i*2*pi*frequencies'*integerSamples/S)/sqrt(S);

sampledValuesDenser = exp(1i*2*pi*frequencies'*realSamples/S)/sqrt(S);



figure;
hold on; box on;

scaleFactor = 2;

color{1}='k';
color{2}='b';
color{3}='m';
color{4}='r';

for eta = 1:S
    
    plot(integerSamples,-scaleFactor*eta+zeros(1,S),'k:','LineWidth',1);
    plot(integerSamples,-scaleFactor*eta+real(sampledValues(eta,:)),[color{abs(frequencies(eta))+1} '*'],'LineWidth',2);
    plot(integerSamples,-scaleFactor*eta+imag(sampledValues(eta,:)),[color{abs(frequencies(eta))+1} '*'],'LineWidth',2);
    plot(realSamples,-scaleFactor*eta+real(sampledValuesDenser(eta,:)),[color{abs(frequencies(eta))+1} '-'],'LineWidth',2);
    plot(realSamples,-scaleFactor*eta+imag(sampledValuesDenser(eta,:)),[color{abs(frequencies(eta))+1} '--'],'LineWidth',2);

end
for s = 0:S-1
    plot(s+zeros(1,S),linspace(-scaleFactor*S-0.5,-0.5,S),'k:','LineWidth',1);
end