%%
clc;
clear ;
clear var;
%% Calculate steps, speed and route

load('walk_1.1.mat', 'Position')       % Load the data file and the corect data.

positionTime = Position.Timestamp(1:end,:);  % move time

Sport_Time = duration(positionTime(end,:) - positionTime(1,:));

Speed = Position.speed(1:end,:); % speed scan was performed at a rate of 10 Hz (0.1 [sec])

averSpeed = mean(Speed)*3.6; % Averege Speed [km/hour].

Max_Speed = max(Speed)*3.6; % Maximum speed [km/hour].

earthCirc = 40075 * 3280; % 40,075 kilometer, convert to ft by multiplying by 3,280  
totaldis = 0; 
stride = 2.5; % ft in step
lat = Position{:,1};
lon = Position{:,2};

%% Processing Loop

for i = 1:(length(lat)-1)  % Loop through every data sample
      lat1 = lat(i); % Latitude of the i’th sample
      lon1 = lon(i); % Longitude of the i’th sample
      lat2 = lat(i+1); % Latitude of the (i+1)’th sample
      lon2 = lon(i+1); % Latitude of the (i+1)’th sample
      diff = distance(lat1, lon1, lat2, lon2); % MATLAB function to compute distance between 2 points on a sphere
                                               
                                               
      dis = (diff/360)*earthCirc; % convert degrees to meter
      totaldis = totaldis + dis;
end

steps = totaldis/stride;

distance = totaldis/3280;

figure(1);
plot(lat,lon);
plot(lat, lon, '-r',lat(1),lon(1),'*g',lat(end),lon(end),'*b','LineWidth',3, 'MarkerSize',10 );
hold on;
legend('Route','Start Point','End Point');
xlabel('Latitude')
ylabel('Longitude');
title(sprintf('Workout Summary : You took %.0f steps and moved %.3f kilometer',steps, distance) );
grid on;
hold off;

%% type of training

if averSpeed > 0 && averSpeed <= 5
    walk = 1;
    
    figure(2);
    plot(averSpeed,Sport_Time,'X');
    title('Walking time and average speed ');
    xlabel('Average Speed [km/h]');
    ylabel('Sport Time [hh:mm:ss]'); grid on; hold on;
    
    fprintf('Your type of training is: Walk ...... ');
    
elseif averSpeed > 5 && averSpeed <= 8
    fast_walking = 1;
    
    figure(2);
    plot(averSpeed,Sport_Time,'X');
    title('Fast walking time and average speed ');
    xlabel('Average Speed [km/h]');
    ylabel('Sport Time'); grid on; hold on;
    
    fprintf('Your type of training is: Fast walking ...... ');
    
elseif averSpeed > 8 && averSpeed <= 20
    running = 1;
    
    figure(2);
    plot(averSpeed,Sport_Time,'X');
    title('Running time and average speed ');
    xlabel('Average Speed [km/h]');
    ylabel('Sport Time'); grid on; hold on;
    
    fprintf('Your type of training is: Running ...... ');
    
elseif averSpeed > 20
    Cycling = 1;
    
    
    figure(2);
    plot(averSpeed,Sport_Time,'X');
    title('Cycling time and average speed ');
    xlabel('Average Speed [km/h]');
    ylabel('Sport Time'); grid on; hold on;
    
    fprintf('Your type of training is: Cycling ...... ');
    
else
    
    walk = 0;
    fast_walking = 0;
    running = 0;
    Cycling = 0;
end

%% Calories you loss in sport active.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% IF you want to know how many calories you loss, Enter 'Y' or 'y'%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = input('Are you want to know how many Calories you loss? [Y/N] ','s');
if c == 'Y' || c == 'y'
    
    
Gender = input('Enter your Gender [M/W]: ','s');

if Gender ~= 'M' || Gender ~= 'W' 
elseif Gender ~= 'm' || Gender ~= 'w'
    Gender = input('Erro, Enter your Gender [M/W]: ','s');
end


Weight = input('Enter your Weight [kg]: ');

if Weight < 12
   Weight = input('Error Weight, Enter your Weight [kg]: ');
   
elseif Weight > 200
    Weight = input('Error Weight, Enter your Weight [kg]: ');
end


Height = input('Enter your height [cm]: ');

if Height < 40
    Height = input('Sorry, is so short, Enter your height [cm]: ');
    
elseif Height > 300
    Height = input('Sorry, is so long, Enter your height [cm]: ');
    
end


Age = input('Enter your Age [years]: ');

if Age < 0
    Age = input('Error Age, Enter your Age [years]: ');
    
elseif Age > 130
    Age = input('Error Age, Enter your Age [years]: ');
    
end

if Gender == 'M' || Gender == 'm'
    BMR_men = 66.47 + (13.75*Weight) + (5.003*Height) - (6.755*Age); %% Weight[kg]    Height[cm]    Age[years]
    
elseif Gender == 'W' || Gender == 'w'
    BMR_Women = 655.1 + (9.563*Weight) + (1.85*Height) - (4.676*Age); %% Weight[kg]    Height[cm]    Age[years]
else
    Gender = input('Error, Enter your Gender [M/W]: ','s');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Your type of activity %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if steps < 8000
    Active = ('Sedentary Active');
    Ac = 1.2;
elseif steps > 8000 && steps < 10000
    Active = ('Lightly Active');
    Ac = 1.375;
elseif  steps > 10000 && steps < 12000
    Active = ('Moderately Active');
    Ac = 1.55;
elseif steps > 12000 && steps < 15000
    Active = ('Very Active');
    Ac = 1.725;
elseif  steps > 15000 
    Active = ('Extra Active');
    Ac = 1.9;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate and plot how many calories you loss in this acttives %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Gender == 'M' || Gender == 'm'
   EEPA_M = (BMR_men *Ac);     % calories you expend in a day (24 Hour) (for men)
   
   figure(3);
   plot(steps,EEPA_M,'*')
   title(sprintf('You took: %.0f steps and you loss %.0f Calories ',steps,EEPA_M));
   xlabel('Steps');
   ylabel('EEPA_M (Calories you loss)');
   grid on;

elseif Gender == 'W' || Gender == 'w'
   EEPA_W = BMR_Women *Ac; % calories you expend in a day (for Women)
   
   figure(3);
   plot(steps,EEPA_W,'*')
   title(sprintf('You took: %.0f steps and you loss %.1f Calories ',steps,EEPA_W));
   xlabel('Steps');
   ylabel('EEPA_W (Calories you loss)');
   grid on;
   
end

elseif c == 'N' || c == 'n'
    fprintf('Thank you.')
end 


