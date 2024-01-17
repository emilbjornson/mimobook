function powerAllocation = functionWaterfilling(totalPower,lambdaInv)
%Compute the power allocation for MIMO point-to-point links, using the
%classic waterfilling algorithm. This is used in the paper:
%
%Emil Björnson, Per Zetterberg, Mats Bengtsson, Björn Ottersten, "Capacity
%Limits and Multiplexing Gains of MIMO Channels with Transceiver
%Impairments," IEEE Communications Letters, vol. 17, no. 1, pp. 91-94,
%January 2013.
%
%This is version 1.0. (Last edited: 2014-03-22)
%
%INPUT:
%totalPower = Total transmit power to be allocated over the singular 
%             directions of the channel
%lambdaInv  = Nt x 1 vector with inverses of the squared singular values of MIMO channel
%             (or the (interference power + noise power)/(channel gain)
%             for each singular direction of the channel).
%
%OUTPUT:
%powerAllocation = Power allocation computed using classical waterfilling

Nt = length(lambdaInv); %Extract number of singular directions
lambdaInvSorted = sort(lambdaInv,'ascend'); %Sort lambdaInv in ascending order

alpha_candidates = (totalPower+cumsum(lambdaInvSorted))./(1:Nt)'; %Compute different values on the Lagrange multiplier (i.e., waterlevel) given that 1,2,...,Nt of the singular directions get non-zero power
optimalIndex = alpha_candidates-lambdaInvSorted(1:end,1)>0 & alpha_candidates-[lambdaInvSorted(2:end,1); Inf]<0; %Find the true Lagrange multiplier alpha by checking which one of the candidates that only turns on the singular directions that are supposed to be on
waterLevel = alpha_candidates(optimalIndex); %Extract the optimal Lagrange multiplier (i.e., waterlevel in the waterfilling analogy)

powerAllocation = waterLevel-lambdaInv; %Compute power allocation
powerAllocation(powerAllocation<0) = 0; %Make sure that inactive singular directions receive zero power