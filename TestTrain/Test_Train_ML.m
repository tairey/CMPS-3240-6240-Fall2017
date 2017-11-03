%Test-Train Algorithm
clc; clear; close all;
file=fopen('HousingPrices.txt');
cells=textscan(file,'%f%f%s%f%f%f','delimiter','\t','headerLines',1);
sqft=cells{1};
price=cells{2};
city=cells{3};
bedrooms=cells{4};
baths=cells{5};

citynum=ones(83,1); 
y=1;
for i=2:83
    if strcmp(city(i),city(i-1))==0
        y=y+1;
    end
    citynum(i)=y/48;
end

%This normalizes the data
min1=min(sqft);
max1=max(sqft);
for i=1:83
    sqft(i)=(sqft(i)-min1)/(max1-min1);
end

min2=min(price);
max2=max(price);
for i=1:83
    price(i)=(price(i)-min2)/(max2-min2);
end

min3=min(bedrooms);
max3=max(bedrooms);
for i=1:83
    bedrooms(i)=(bedrooms(i)-min3)/(max3-min3);
end

min4=min(baths);
max4=max(baths);
for i=1:83
    baths(i)=(baths(i)-min4)/(max4-min4);
end

table(:,1)=[price];
table(:,2)=[sqft];
table(:,3)=[bedrooms];
table(:,4)=[baths];
table(:,5)=[citynum];

train=table(1:58,:);
test=table(59:83,:);
w=[0 0 0 0];

%R is the chosen learning rate
R=0.1;
for i=1:58
    for j=1:4
        y1=price(i);
        y2=w(1)*train(i,1)+w(2)*train(i,2)+w(3)*train(i,3)+w(4)*train(i,4);
        %Weight update rule:
        dw=R*train(i,j)*(y1-y2);
        w(j)=w(j)+dw;
    end
end

%Now the test
sumerror=0;
for i=1:25
    Price1=w(1) + w(2)*test(i,2) + w(3)*test(i,3) + w(4)*test(i,4);
    PredPrice=Price1*(max2-min2)+min2;
    RealPrice=price(i)*(max2-min2)+min2;
    
    %The following is a simple perceptron that takes the predicted price,
    %compares it to the selected value, and classifies it as too expensive
    %or not too expensive.
        if PredPrice > 700000
            fprintf('House is too expensive\n');
        else
            fprintf('House is not too expensive\n');
        end
    %To compute the MSE we first square the difference between the
    %predicted price and the real price.
    SqError=(Price1-price(i))^2;
    sumerror=sumerror+SqError;
end

%All that's left to calculate Mean Squared Error is finding the mean:
MSE=sumerror/i;
fprintf('Mean Squared Error: %f\n',MSE);
    





    
