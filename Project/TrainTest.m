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
table=table(1:3176,4:8);

%table format: 
%imdb   rotten  

for i=1:length(rate);
    if rate(i)>=8
        rating(i,1)="Good";
    else
        rating(i,1)="Bad";
    end
end
        

%Making a larger cell
% title=text(2:3177,1);
% type=text(2:3177,10);
% director=text(2:3177,11);
% netflix=text(2:3177,28);

% C=cell(3176,4);
% C(:,1)=title;
% C(:,2)=type;
% C(:,3)=director;
% C(:,4)=netflix;


SVMStruct=svmtrain([imdb rotten],rating,'ShowPlot',true)





