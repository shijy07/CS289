%%
%CS 289 Homework 4
%Problem 3
%Jiaying Shi
%SID: 24978491
%shijy07@berkeley.edu
%%
clear all;
clc;
%%
load 'spam.mat';
ytrain=double(ytrain);
%%
% Take log of data
XtrainL=processTrainData(Xtrain,2);
XtrainL=[ones(length(ytrain),1) XtrainL];
lambdaL=0.1;
alphaL=0.01;
beta=zeros(size(XtrainL,2),1);
betaPrev=beta;
muL=[];
betaIterL=[];
epsilon=0.00001;
prevMu=zeros(length(ytrain),1);
lossL=[];
M=length(ytrain);
prevLossL=1;
for iter=1:1000
    [mui,beta]=gradientDescentIter(XtrainL,ytrain,beta,alphaL,lambdaL);
    muL=[muL mui];
    betaIterL=[betaIterL beta];
    lossIter=lambdaL*norm(beta)^2-1/M*ytrain'*log(mui+0.000001)-1/M*(1-ytrain)'*log(1-mui+0.000001);
    diff=prevLossL-lossIter;
    prevLossL=lossIter;
    lossL=[lossL;lossIter];
    if(abs(diff)<epsilon)
        break;
    end
end
P3L=plot(1:length(lossL),lossL);
title('Batch Gradient Descent Method using data preprocessed using ii)');
xlabel('Iteration');
ylabel('Loss');
saveas(P3L,'p3L.jpg');
