clc; clear; close all;

%Data Reader
table=xlsread('MovieData');
[ndata, text, alldata] = xlsread('MovieData');
table=table(:,1:18);
imdb=table(1:3176,13);
rotten=table(1:3176,14);
rate=table(1:3176,2);
table(:,2:9)=[];
table(:,4)=[];
Data=[table(1:3176,4:5) table(1:3176,7:8)];

%Classifier Vector
for i=1:length(rate);
    if rate(i)>=7
        rating(i,1)="Good";
    else
        rating(i,1)="Bad";
    end
end

%Data is the data we will use to train the SVM
%It consists of the following attributes:
%IMDB Rating    Rotten Tomatoes Rating       Runtime     Year Released


%The SVM can then be used to compare to the "rating vector" that classifies the
%movies as good or bad recommendations.
        

%Strings of variables that may be helpful to the user
title=string(text(2:3177,1));
type=string(text(2:3177,10));
director=string(text(2:3177,11));
netflix=string(text(2:3177,28));

%Algorithm 1
%Separate into train and test (70% of 3176 is 2223) using the first 70% of 
%items listed (the earliest movies):
    
train1=Data(1:2223,:);
test1=Data(2224:3176,:);

trainR1=rating(1:2223,:);
testR1=rating(2224:3176,:);

SVMStruct1=fitcsvm(train1,trainR1)
label1=predict(SVMStruct1,test1);

%Evaluation:
TP=0;
FP=0;
FN=0;
for i=1:953
    if strcmp(testR1(i),'Good')==1 && strcmp(label1(i),'Good')==1
        TP=TP+1;
    elseif strcmp(testR1(i),'Bad')==1 && strcmp(label1(i),'Good')==1
        FP=FP+1;
    elseif strcmp(testR1(i),'Good')==1 && strcmp(label1(i),'Bad')==1
        FN=FN+1;
    end
end

precision=TP/(TP+FP)
recall=TP/(TP+FN)
F1=2*precision*recall/(precision+recall)


%Algorithm 2
%train is randomly sampled from the data set, not the first 70%
order=randperm(3176,3176);

for i=1:3176
    if i<2224
        train2(i,:)=Data(order(i),:);
        trainR2(i,1)=rating(order(i));
    else 
        test2(i-2223,:)=Data(order(i),:);
        testR2(i-2223,:)=rating(order(i));
    end
end

SVMStruct2=fitcsvm(train2,trainR2)
label2=predict(SVMStruct2,test2);

%Evaluation:
TP=0;
FP=0;
FN=0;
for i=1:953
    if strcmp(testR2(i),'Good')==1 && strcmp(label2(i),'Good')==1
        TP=TP+1;
    elseif strcmp(testR2(i),'Bad')==1 && strcmp(label2(i),'Good')==1
        FP=FP+1;
    elseif strcmp(testR2(i),'Good')==1 && strcmp(label2(i),'Bad')==1
        FN=FN+1;
    end
end

precision=TP/(TP+FP)
recall=TP/(TP+FN)
F1=2*precision*recall/(precision+recall)

%Algorithm 3
%This uses a different function, fitcecoc. It returns a full, trained, 
%multiclass, error-correcting output codes (ECOC) model using the predictors 
%given. fitcecoc uses K(K ? 1)/2 binary SVM, where K is the number 
%of unique class labels.
SVMStruct3=fitcecoc(train2,trainR2)
label3=predict(SVMStruct3,test2);

%Evaluation:
TP=0;
FP=0;
FN=0;
for i=1:953
    if strcmp(testR2(i),'Good')==1 && strcmp(label3(i),'Good')==1
        TP=TP+1;
    elseif strcmp(testR2(i),'Bad')==1 && strcmp(label3(i),'Good')==1
        FP=FP+1;
    elseif strcmp(testR2(i),'Good')==1 && strcmp(label3(i),'Bad')==1
        FN=FN+1;
    end
end

precision=TP/(TP+FP)
recall=TP/(TP+FN)
F1=2*precision*recall/(precision+recall)

%Algorithm 4
%This one normalizes the year the film was released so a film being
%released later has less of an impact on the release date.

for i=1:3176
    Data(i,4)=(Data(i,4)-1915)/100;
end

order=randperm(3176,3176);

for i=1:3176
    if i<2224
        train4(i,:)=Data(order(i),:);
        trainR4(i,1)=rating(order(i));
    else 
        test4(i-2223,:)=Data(order(i),:);
        testR4(i-2223,:)=rating(order(i));
    end
end

SVMStruct4=fitcsvm(train4,trainR4)
label4=predict(SVMStruct4,test4);

%Evaluation:
TP=0;
FP=0;
FN=0;
for i=1:953
    if strcmp(testR4(i),'Good')==1 && strcmp(label4(i),'Good')==1
        TP=TP+1;
    elseif strcmp(testR4(i),'Bad')==1 && strcmp(label4(i),'Good')==1
        FP=FP+1;
    elseif strcmp(testR4(i),'Good')==1 && strcmp(label4(i),'Bad')==1
        FN=FN+1;
    end
end

precision=TP/(TP+FP)
recall=TP/(TP+FN)
F1=2*precision*recall/(precision+recall)


