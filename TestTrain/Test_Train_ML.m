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
for x=2:83
    if strcmp(city(x),city(x-1))==0
        y=y+1;
    end
    citynum(x)=y/48;
end

%This normalizes the data
min1=min(sqft);
max1=max(sqft);
for x=1:83
    sqft(x)=(sqft(x)-min1)/max1;
end

min2=min(price);
max2=max(price);
for x=1:83
    price(x)=(price(x)-min2)/max2;
end

min3=min(bedrooms);
max3=max(bedrooms);
for x=1:83
    bedrooms(x)=(bedrooms(x)-min3)/max3;
end

min4=min(baths);
max4=max(baths);
for x=1:83
    baths(x)=(baths(x)-min4)/max4;
end

table(:,1)=[price];
table(:,2)=[sqft];
table(:,3)=[bedrooms];
table(:,4)=[baths];
table(:,5)=[citynum];

train=table(1:58,:);
test=table(59:83,:);
w=[0 0 0 0];

R=0.03;
td=0;
for x=1:57
    for i=1:4
        td=train(x+1,i);
        od=w(i)*train(x,i);
        dw=R*(td-od)*train(x,i);
        w(i)=w(i)+dw;
    end
end

%Now the test
sumerror=0;
for i=1:25
    PredPrice=w(1) + w(2)*test(i,2) + w(3)*test(i,3) + w(4)*test(i,4);
    RealPrice=test(i,1);
        if (PredPrice*max2)+min2 > 500000
            fprintf('House is too expensive\n');
        else
            fprintf('House is not too expensive\n');
        end
    Error=abs(RealPrice-PredPrice);
    sumerror=sumerror+Error;
end

%Mean Squared Error:
MSE=sqrt(sumerror/25);
fprintf('Mean Squared Error: %f\n',MSE);
    





    