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

%Algorithm 3 performed the best among all algorithms tested
%train is randomly sampled from the data set, not the first 70%

%This uses the function fitcecoc. It returns a full, trained, multiclass, 
%error-correcting output codes (ECOC) model using the predictors given. 
%fitcecoc uses K(K - 1)/2 binary SVM, where K is the number 
%of unique class labels.

%The following code randomizes the rows, so that the training data is
%chosen at random, rather than the first 70% that appears.
order=randperm(3176,3176);

for i=1:3176
    if i<2224
        train1(i,:)=Data(order(i),:);
        trainR1(i,1)=rating(order(i));
    else 
        test1(i-2223,:)=Data(order(i),:);
        testR1(i-2223,:)=rating(order(i));
    end
end


%Implementation of the fitcecoc function:
SVMStruct=fitcecoc(train1,trainR1)
label1=predict(SVMStruct,test1);

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

%Preferred Evaluation tool is precision: the most important feature of the
%program is to be able to correctly predict movies the user would like.
%Regardless, here are the calculated values for precision, recall, and F1.
precision=TP/(TP+FP)
recall=TP/(TP+FN)
F1=2*precision*recall/(precision+recall)


%Now to give recommendations to new movies that will be used
[ndata, text, alldata] = xlsread('NewMovies.xlsx');
[label2,score]=predict(SVMStruct,ndata);

%Score is a vector that shows how strongly it classifies the movie
%the higher the magnitude, the more strongly it feels about recommending
%the movie as good or bad
sortscore=sort(abs(score),'descend');

%The following code prints out the highest recommendations in order, and
%then the lowest recommendations in order
fprintf('Recommendations:\n');
for i=1:5
    for j=1:50
        if sortscore(i)==abs(score(j))
            fprintf("Film: %-25.25s Director: %s\n",text{j,1},text{j,2})
        end
    end
end

fprintf('\n\nBest to Avoid:\n');
for i=1:5
    for j=1:50
        if sortscore(i,2)==abs(score(j,2))
            fprintf("Film: %-25.25s Director: %s\n",text{j,1},text{j,2})
        end
    end
end

%Voilà


