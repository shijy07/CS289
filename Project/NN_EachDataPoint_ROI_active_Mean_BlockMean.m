clear all;
clc;
%%
%Jiaying Shi
%shijy07@berkeley.edu
%%
%Load Data
load 'sent_RoI_act_mean.mat'
nIn=7;
nHid=4;
nOut=2;
trainDataRaw=[train_pic1;train_pic2;train_pic4;train_pic5];
trainLabel=[train_pic_label1;train_pic_label2;train_pic_label4;train_pic_label5];


%%
%Preprocess
trainData=zeros(size(trainDataRaw,1),size(trainDataRaw,2));
trainData(1:8,:)=trainDataRaw(1:8,:);
for i=9:size(trainDataRaw,1);
    t=floor((i-1)/8);
    trainData(i,:)=trainDataRaw(i,:)-mean(trainDataRaw((i-8):(i-1),:))-mean(trainDataRaw(((t-1)*8+1):(t*8),:));
end
n=length(trainLabel);
indx=randsample(n,n);
trainData=trainDataRaw(indx,:);
trainLabel=trainLabel(indx);
nTest=400;
%%
%reshape data
meanTrain=mean(trainData);
stdTrain=std(trainData);
for i=1:size(trainData,2);
    if(stdTrain(i)~=0)
        trainData(:,i)=(trainData(:,i)-meanTrain(i))/stdTrain(i);
        trainData(:,i)=detrend(trainData(:,i));
    end
end
%%
%get validation data
train_Data=trainData((nTest+1):n,:);
train_Label=trainLabel((nTest+1):n);
test_Data=trainData(1:nTest,:);
test_Label=trainLabel(1:nTest);

%%
%
maxIter=3000;
stepSize=1;
nAvg=3196-400;
tic;
[W1,W2,accuracyClassification,trainError]=trainNN(train_Data,train_Label,nHid,nOut,2,maxIter,stepSize,nAvg);
toc;
[errorRate,predictLabel,nnOutput]= predictNN(W1,W2,test_Data,test_Label);
f1=plot(trainError);
title('Cross-Entropy Error over Iteration');
xlabel('Iteration');
ylabel('Cross-Entropy Error');
% saveas(f1,'CE.jpg');

f2=figure;
plot(accuracyClassification);
title('Classification Accuracy with Cross-Entropy Error');
xlabel('Iteration');
ylabel('Classification Accuracy');
% saveas(f2,'CE_accu.jpg');
